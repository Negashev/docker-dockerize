## Synopsis
It contains `dockerize` to generate configuration files.

It is also possible to **automatically** generate configuration files from deflate `*.tmpl` files using `wget`, this is enough to add ENV variable `DOCKERIZE_GET` with links through the sign `;`

## Code Example

```docker run -v /config -e 'DOCKERIZE_GET=https://raw.githubusercontent.com/Negashev/docker-dockerize/master/examples/sensu.conf.tmpl;https://raw.githubusercontent.com/Negashev/docker-dockerize/master/examples/nginx.conf.tmpl' --name config negash/dockerize```

This command raises a container called `config`, which will deflate 2 file:

https://raw.githubusercontent.com/Negashev/docker-dockerize/master/examples/sensu.conf.tmpl
https://raw.githubusercontent.com/Negashev/docker-dockerize/master/examples/nginx.conf.tmpl

and create two configuration files with replace `ENV` variables in the folder `/config`:
```
sensu.conf
nginx.conf
```
The container is then turned off

Then you can use data from `config` container

```docker run -it --volumes-from config ubuntu /bin/bash```

## Installation
docker pull negash/dockerize

## API Reference

To add a folder in `/volume`, you can use the following hacks:

pass `ENV` variable DH_* and DF_*
```
...
-e DH_sensu=negash.ru/s/sensu
-e DF_sensu=api.json.tmpl;transport.json.tmpl
...
```

and after start container get files:

http://negash.ru/s/sensu/api.json.tmpl
http://negash.ru/s/sensu/transport.json.tmpl

and save this to `/config/sensu`

## Example

```docker run -v /config -e DH_sensu=negash.ru/s/sensu -e DF_sensu=api.json.tmpl;transport.json.tmpl --name config negash/dockerize```

## License

MIT