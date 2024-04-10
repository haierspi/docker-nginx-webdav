# WebDav Server ( Nginx )

from `nginx:1.22.1-alpine`


## ENV

|  |  |
| - | - |
| Served Directory | `/media/data`                        |
| HTTP Port        | `80`                                 |
| HTTPS Port       | `443`                                |
| Auth Type        | `Basic`                              |
| Auth Username    | `webdav`                             |
| Auth Password    | `webdav`                             |
| SSL Path         | cert `/cert.pem`; key `/privkey.pem` |

## Usage

### http
```sh
docker run --restart always --name webdav --publish 80:80 \
	-e USERNAME=webdav -e PASSWORD=webdav \
	-v /data/dav:/media/data \
	-d haierspi/docker-nginx-webdav-ssl:latest
```

### https
```sh
docker run --restart always --name webdav --publish 443:443 \
	-e USERNAME=webdav -e PASSWORD=webdav \
	-v /data/dav:/media/data \
	-v /data/dav-conf/privkey.pem:/privkey.pem -v /data/dav-conf/cert.pem:/cert.pem \
	-d haierspi/docker-nginx-webdav-ssl:latest
```

## Github

https://github.com/haierspi/docker-nginx-webdav

