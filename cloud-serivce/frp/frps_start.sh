#!/bin/bash

sed -i "s/\${TOKEN}/${TOKEN:?}/g" /frp/frps.ini
/frp/frps -c /frp/frps.ini
