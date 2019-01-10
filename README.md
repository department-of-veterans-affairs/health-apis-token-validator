# health-apis-token-validator

## Validate-Token Kong Plugin

This repository contains a Kong plugin to validate a supplied OAuth token.  It can be installed on a Kong instance and configured to run against the entire instance, specific API's, or specific routes.

### Building

> Luarocks must be installed to build.

Run `luarocks pack health-apis-token-validator-0.1-1.rockspec` to package the plugin into a Lua "rock" which can then be copied and installed on a Kong instance.

### Configuration

Once the plugin is installed on the Kong instance, it can be configured via the Admin port.  Replace config entries with the correct values for your environment.

```
{
    "name": "health-apis-token-validator",
    "config": {
        "verification_url": "{verification_url}",
        "verification_timeout": {verification_timeout},
        "api_key": "{api_key}"
    },
    "enabled": true
}
```

- [Local development](development/README.md)

