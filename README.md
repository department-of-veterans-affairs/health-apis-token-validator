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

Once the containers have started, use `docker ps -a` to identify the local kong container to copy the plugin to.

```
docker cp validate-token-kong-plugin {container_id}:/usr/local/kong/validate-token-kong-plugin
```

Once the plugin is copied, ssh into the container.

```
winpty docker exec -it ${container-id} sh
```

Navigate to `/usr/local/kong/validate-token-kong-plugin` and install the plugin using luarocks

```
luarocks make
```

Now, the constants.lua file needs to be updated at `/usr/local/share/lua/5.1/kong/constants.lua`.  Add `"validate-token",` to the end of the `local plugins` list.

Finish with `kong reload` and navigate to `localhost:8001/plugins/enabled/` to verify that `validate-token` plugin has been enabled.