return {
  no_consumer = true,
  fields = {
    verification_url = {type = "string"},
    verification_timeout = {type = "number", default = 10000},
    verification_host = {type = "string"}
    api_key = {type = "string"}
  }
}
