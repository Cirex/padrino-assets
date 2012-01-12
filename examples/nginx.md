Nginx Configuration Example
=============================

``` nginx
location ~ ^/(assets)/  {
  add_header Cache-Control public;
  root /path/to/public;
  gzip_static on;
  expires max;
}
```