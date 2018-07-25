#!/bin/bash

USER=${USER:=r}
GROUP=${GROUP:=r}
USERID=${USERID:=1000}
GROUPID=${GROUPID:=1000}
ROOT=${ROOT:=FALSE}

groupadd -g $GROUPID $GROUP > /dev/null
useradd -m -u $USERID -g $GROUPID $USER > /dev/null
touch /home/$USER/.sudo_as_admin_successful

if [ "$ROOT" == "TRUE" ]; then
    adduser $USER sudo > /dev/null
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
fi

# start fake X server
nohup Xvfb :6 -screen 0 1280x1024x24 > /X.log 2>&1 &
export DISPLAY=:6

sudo -i -u $USER "$@"
