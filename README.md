[![](https://images.microbadger.com/badges/image/brejoc/nextcloud.svg)](https://microbadger.com/images/brejoc/nextcloud "Get your own image badge on microbadger.com")

This builds a docker container with nextcloud running in it. It uses a docker volume in order to allow you to persist the data and config between different containers. It is setup for usage with MySQL and Sqlite but, it does not have a linked MySQL container. Pull-Requests are welcome!

# Usage #

## Building the image ##

run `docker build -t 'brejoc/nextcloud' .`

## Running ##

1. You can either build this image locally or just fetch it from the docker hub: `brejoc/nextcloud`.
2. Run it `docker run -d -m 1g -p 127.0.0.1:9000:80 --name="my_docker_nextcloud" -v /var/nextcloud/data:/var/www/nextcloud/data -v /var/nextcloud/config:/var/www/nextcloud/config brejoc/nextcloud`
3. Setup a reverse proxy to server it from port 80:

```
server {
	     listen 80;
	     server_name nextcloud.example.com;
	     return 301 https://$host$request_uri;
}

server {
	listen 443;
	server_name nextcloud.example.com;
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
