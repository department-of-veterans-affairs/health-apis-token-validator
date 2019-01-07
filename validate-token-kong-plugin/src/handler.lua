local ValidateToken = require("kong.plugins.base_plugin"):extend()

local http = require "resty.http"
local responses = require "kong.tools.responses"
local cjson = require "cjson.safe"

local find = string.find
local format = string.format

local TYPE_JSON = "application/json"

local INVALID_TOKEN =
  '{ "resourceType": "OperationOutcome",\n' ..
  '  "id": "exception",\n' ..
  '  "text": {\n' ..
  '      "status": "additional",\n' ..
  '      "div": "<div xmlns=\\"http://www.w3.org/1999/xhtml\\"><p>invalid token.</p></div>"\n' ..
  '  },\n' ..
  '  "issue": [\n' ..
  '      {\n' ..
  '          "severity": "error",\n' ..
  '          "code": "exception",\n' ..
  '          "details": {\n' ..
  '              "text": "invalid token."\n' ..
  '          }\n' ..
  '      }\n' ..
  '  ]\n' ..
  '}'

function ValidateToken:new()
  ValidateToken.super.new(self, "validate-token")

end

function ValidateToken:access(conf)
  ValidateToken.super.access(self)

  self.conf = conf

  if (ngx.req.get_headers()["Authorization"] == nil) then
      return self:send_response(401, "Unauthorized")
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
    return self:send_response(500, "Internal Server Error")
  end

  -- Get the status and body of the verification request
  -- So we can be done with the connection
  local verification_res_status = verification_res.status
  local verification_res_body = verification_res.body

  -- If unauthorized, we block the user
  if (verification_res_status == 401) then
    return self:send_response(401, "Unauthorized")
  end

  -- An unexpected condition
  if (verification_res_status < 200 or verification_res_status > 299) then
    return self:send_response(500, "Internal Server Error")
  end

  -- The validate endpoint is actually checking the expiration
  local json = cjson.decode(verification_res_body)
  ngx.log(ngx.ERR, "EXP: ", json.data.attributes.exp)


end

-- Format and send the response to the client
function ValidateToken:send_response(status_code, message)

  ngx.status = status_code
  ngx.header["Content-Type"] = TYPE_JSON
  
  if (status_code == 401) then
	ngx.say(INVALID_TOKEN)
  elseif (status_code == 500) then
    ngx.say("Error validating token")
  else
    ngx.say("Other error")
  end
  
  ngx.exit(status_code)
end


ValidateToken.PRIORITY = 1010

return ValidateToken
