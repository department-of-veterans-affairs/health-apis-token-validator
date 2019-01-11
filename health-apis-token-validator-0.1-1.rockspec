package = "health-apis-token-validator"
version = "0.1-1"
source = {
  url = "git://github.com/department-of-veterans-affairs/health-apis-token-validator.git",
}
description = {
  summary = "A Kong plugin to perform FHIR-specific token validation and prior to API calls"
}
dependencies = {
  "lua >= 5.1"
  -- If you depend on other rocks, add them here
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.health-apis-token-validator.handler"] = "src/handler.lua",
    ["kong.plugins.health-apis-token-validator.schema"] = "src/schema.lua"
  }
}