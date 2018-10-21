#!/bin/bash

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < /tmp/passwd_template > /tmp/passwd
export LD_PRELOAD=/usr/lib/libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group
export GOPATH=$HOME/goproject
export PATH=$HOME/go/bin:$PATH:$GOPATH/bin:$HOME/tool
export RCLONE_CONFIG=$HOME/config/rclone.conf

cat << EOF >> ~/.profile
export LD_PRELOAD=/usr/lib/libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group
export GOPATH=$HOME/goproject
export PATH=$HOME/go/bin:$PATH:$GOPATH/bin:$HOME/tool
export RCLONE_CONFIG=$HOME/config/rclone.conf
EOF

cat << EOF >> ~/.bashrc
export LD_PRELOAD=/usr/lib/libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group
export GOPATH=$HOME/goproject
export PATH=$HOME/go/bin:$PATH:$GOPATH/bin:$HOME/tool
export RCLONE_CONFIG=$HOME/config/rclone.conf
EOF


gotty --port 8080 -c "${GOTTY_USER}:${GOTTY_PASS}" -w bash 
