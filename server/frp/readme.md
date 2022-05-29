## frp

server

```bash
wget https://raw.githubusercontent.com/alacine/dotfiles/master/server/frp/docker-compose.yml
# ===
# edit docker-compose.yml
# ===
docker-compose up -d
```

client

edit `/etc/frp/frpc.ini`

```
[common]
server_addr = 1.2.3.4
server_port = 7000
token = xxxxxx

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000
```
