# Client library for open-uploader

- [open-uploader-client](https://github.com/k-yamada/open-uploader-client)

# Build

    $ bundle install
    $ thor build:build

# Start server with nginx

## setup nginx

- write nginx.conf

```
    # /usr/local/nginx/conf/nginx.conf

    user  nobody;
    worker_processes  1;
    pid /tmp/nginx.pid;
    error_log  /var/log/nginx/error.log warn;

    events {
        worker_connections  1024;
    }

    http {
        include       mime.types;
        include       open-uploader.conf;
        default_type  application/octet-stream;
    ...
    }
```

- write open-uploader.conf

```
    # /usr/local/nginx/conf/nginx.conf

    upstream open-uploader {
      server unix:/tmp/open-uploader.sock fail_timeout=0;
    }

    server {
      listen 80;
      server_name your.domain.com;
      client_max_body_size 4G;
      keepalive_timeout 5;
      root /var/www/open-uploader;

      try_files $uri/index.html $uri.html $uri @open-uploader;

      location @open-uploader{
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_pass http://open-uploader;
      }

      location = /favicon.ico {
        root /var/www/open-uploader/public;
      }

      # asset pipeline
      location ~ ^/assets/ {
        root /var/www/open-uploader/public;
      }

      # Rails error pages
      error_page 500 502 503 504 /500.html;
      location = /500.html {
        root /var/www/open-uploader;
      }
    }
```

- restart nginx

    $ sudo service nginx restart

## start unicorn

    $ thor unicorn:start
