package = "health-apis-static-token-handler"
version = "0.1-1"
source = {
  url = "git://github.com/department-of-veterans-affairs/health-apis-token-validator.git",
}
description = {
  summary = "A Kong plugin to return a static access token used for customer testing"
}
dependencies = {
  "lua >= 5.1"
  -- If you depend on other rocks, add them here
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.health-apis-static-token-handler.handler"] = "kong/plugins/health-apis-static-token-handler/handler.lua",
    ["kong.plugins.health-apis-static-token-handler.schema"] = "kong/plugins/health-apis-static-token-handler/schema.lua"
  }
}