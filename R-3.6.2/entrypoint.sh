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
chown $USER:$GROUP /CRAN-library
chown $USER:$GROUP /CRAN
sudo -u $USER touch $HOME/.sudo_as_admin_successful

if [ "$ROOT" == "TRUE" ]; then
    adduser $USER sudo > /dev/null
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
fi

# R is installed in /usr/local
# because of some security policy, it is not possible to set PATH here for the
# user the sudo will use.
# export PATH=$PATH:$R_HOME/bin

# start fake X server
nohup Xvfb :6 -screen 0 1280x1024x24 > /X.log 2>&1 &
export DISPLAY=:6

sudo -E -s -u $USER "$@"
