local ValidateToken = require("kong.plugins.base_plugin"):extend()

local http = require "resty.http"
local responses = require "kong.tools.responses"
local cjson = require "cjson.safe"

local find = string.find
local format = string.format

local TYPE_JSON = "application/json"

local OPERATIONAL_OUTCOME_TEMPLATE =
  '{ "resourceType": "OperationOutcome",\n' ..
  '  "id": "exception",\n' ..
  '  "text": {\n' ..
  '      "status": "additional",\n' ..
  '      "div": "<div xmlns=\\"http://www.w3.org/1999/xhtml\\"><p>%s</p></div>"\n' ..
  '  },\n' ..
  '  "issue": [\n' ..
  '      {\n' ..
  '          "severity": "error",\n' ..
  '          "code": "exception",\n' ..
  '          "details": {\n' ..
  '              "text": "%s"\n' ..
  '          }\n' ..
  '      }\n' ..
  '  ]\n' ..
  '}'

local INVALID_TOKEN = "invalid token."
local BAD_VALIDATE_ENDPOINT = "Validate endpoint not found."
local VALIDATE_ERROR = "Error validating token."

function ValidateToken:new()
  ValidateToken.super.new(self, "validate-token")

end

function ValidateToken:access(conf)
  ValidateToken.super.access(self)

  self.conf = conf

  if (ngx.req.get_headers()["Authorization"] == nil) then
      return self:send_response(401, INVALID_TOKEN)
  end

  local client = http.new()
  client:set_timeout(self.conf.verification_timeout)

  local verification_res, err = client:request_uri(self.conf.verification_url, {
    method = "GET",
    ssl_verify = false,
    headers = {
      Authorization = ngx.req.get_headers()["Authorization"],
      apiKey = self.conf.api_key,
    },
  })

  if not verification_res then
    -- Error making request to validate endpoint
    return self:send_response(404, BAD_VALIDATE_ENDPOINT)
  end

  -- Get the status and body of the verification request
  -- So we can be done with the connection
  local verification_res_status = verification_res.status
  local verification_res_body = verification_res.body

  -- If unauthorized, we block the user
  if (verification_res_status == 401) then
    return self:send_response(401, INVALID_TOKEN)
  end

  -- An unexpected condition
  if (verification_res_status < 200 or verification_res_status > 299) then
    return self:send_response(500, VALIDATE_ERROR)
  end

  -- The validate endpoint is actually checking the expiration
  local json = cjson.decode(verification_res_body)
  ngx.log(ngx.ERR, "EXP: ", json.data.attributes.exp)


end

-- Format and send the response to the client
function ValidateToken:send_response(status_code, message)

  ngx.status = status_code
  ngx.header["Content-Type"] = TYPE_JSON

  ngx.say(format(OPERATIONAL_OUTCOME_TEMPLATE, message, message))

  ngx.exit(status_code)
end


ValidateToken.PRIORITY = 1010

return ValidateToken