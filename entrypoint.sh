#!/bin/bash

USER=${USER:=r}
GROUP=${GROUP:=r}
USERID=${USERID:=1000}
GROUPID=${GROUPID:=1000}
ROOT=${ROOT:=FALSE}
HOME=/home/$USER

groupadd -g $GROUPID $GROUP > /dev/null
useradd -u $USERID -g $GROUPID $USER > /dev/null

[ -d $HOME ] || mkdir $HOME

# one would think that it can be done with useradd -m, but if the container is
# run with a mount into $HOME then $HOME will have root permissions
chown $USER:$GROUP $HOME
chown $USER:$GROUP /CRAN/{lib,src,src-extracted}
chown $USER:$GROUP /BIOC/{lib,src}
sudo -u $USER touch $HOME/.sudo_as_admin_successful

if [ "$ROOT" == "TRUE" ]; then
    adduser $USER sudo > /dev/null
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
    echo 'Defaults env_keep += "R_LIBS R_DYNTRACE_HOME"' >> /etc/sudoers
fi

# start fake X server
nohup Xvfb :6 -screen 0 1280x1024x24 > /X.log 2>&1 &
export DISPLAY=:6

sudo -E -i -u $USER "$@"
