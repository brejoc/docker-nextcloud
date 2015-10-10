This builds a docker container with owncloud running in it. It uses a docker volume in order to allow you to persist the data and config between different containers. It is setup for usage with MySQL and Sqlite but, it does not have a linked MySQL container. Pull-Requests are welcome!

# Usage #

## Building the image ##

run `docker build -t 'brejoc/owncloud' .`

## Running ##

1. You need to build the image, since this Dockerfile is not uploaded to the docker registry.
2. Run it `docker run -d -m 1g -p 127.0.0.1:9000:80 --name="my_docker_owncloud" -v /var/owncloud/data:/var/www/owncloud/data -v /var/owncloud/config:/var/www/owncloud/config brejoc/owncloud`
3. Setup a reverse proxy to it

```
server {
	     listen 80;
	     server_name owncloud.example.com;
	     return 301 https://$host$request_uri;
}

server {
	listen 443;
	server_name owncloud.example.com;
	ssl on;
	ssl_certificate /etc/ssl/private/example_com.cert;
	ssl_certificate_key /etc/ssl/private/example_com.key;
	location / {
		proxy_pass			http://127.0.0.1:9000;
		proxy_redirect		off;
		proxy_buffering		off;
		proxy_set_header	Host	$host;
		proxy_set_header	X-Real-IP	$remote_addr;
		proxy_set_header	X-Forwarded-For	$proxy_add_x_forwarded_for;
	}
}
```
