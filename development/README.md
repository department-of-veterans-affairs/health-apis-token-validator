# Health-Apis-Token-Validator Kong Plugin

### Local development

This repository contains a basic docker-compose.yml file that will stand up a Postgres db and kong instance for development.

```
docker-compose up
```

Once the containers have started, use `docker ps -a` to identify the local kong container to copy the plugin to.

```
docker cp . {container_id}:/usr/local/kong/health-apis-token-validator

```

Once the plugin is copied, ssh into the container.  Note, the extra `development` folder and `README.md` file can be removed.

```
winpty docker exec -it ${container-id} sh
```

Navigate to `/usr/local/kong/health-apis-token-validator` and install the plugin using luarocks

```
luarocks make
```

Now, the constants.lua file needs to be updated at `/usr/local/share/lua/5.1/kong/constants.lua`.  Add `"health-apis-token-validator",` to the end of the `local plugins` list.

Finish with `kong reload` and navigate to `localhost:8001/plugins/enabled/` to verify that `health-apis-token-validator` plugin has been enabled.


> Note: With Kong, enabled means the plugin is available for use, not in use.  You must still install the plugin globally or on your desired Kong route with a POST call.