# health-apis-token-validator

## Validate-Token Kong Plugin

This repository contains a Kong plugin to validate a supplied OAuth token.  It can be installed on a Kong instance and configured to run against the entire instance, specific API's, or specific routes.


### Configuration

Once the plugin is installed on the Kong instance, it can be configured via the Admin port.  Replace config entries with the correct values for your environment.

```
{
    "name": "validate-token",
    "config": {
        "verification_url": "{verification_url}",
        "verification_timeout": {verification_timeout},
        "api_key": "{api_key}"
    },
    "enabled": true
}
```


### Local development

This repository contains a basic docker-compose.yml file that will stand up a Postgres db and kong instance for development.

```
docker-compose up
```