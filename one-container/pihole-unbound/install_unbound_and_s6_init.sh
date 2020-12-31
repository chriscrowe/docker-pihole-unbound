#!/bin/bash -e
echo "###########################"
echo "STARTING UNBOUND!"
echo "###########################"
/etc/init.d/unbound start
/s6-init