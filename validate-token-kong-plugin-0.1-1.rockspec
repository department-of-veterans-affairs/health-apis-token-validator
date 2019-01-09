package = "validate-token-kong-plugin"
version = "0.1-1"
source = {
  url = "git://github.com/department-of-veterans-affairs/health-apis-token-validator.git",
}
description = {
  summary = "A Kong plugin to perform token validation prior to API calls"
}
dependencies = {
  "lua >= 5.1"
  -- If you depend on other rocks, add them here
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.validate-token.handler"] = "src/handler.lua",
    ["kong.plugins.validate-token.schema"] = "src/schema.lua"
  }
}