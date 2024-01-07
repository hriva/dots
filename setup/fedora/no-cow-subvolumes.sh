#!/usr/bin/env bash

if [ $UID -ne 0 ]; then
  echo "This script most be run as root"
fi 

IMAGE_DIR=/var/lib/libvirt/images
if [ -d $IMAGE_DIR ]; then
  if [ -z "$(ls -A $IMAGE_DIR)" ]; then
    echo "DIR $IMAGE_DIR must be empty"
    exit
  fi
  rmdir $IMAGE_DIR
fi

btrfs subvolume create $IMAGE_DIR
chcon -t virt_image_t $IMAGE_DIR
chmod 722 $IMAGE_DIR
setfacl -m u:qemu:rwx $IMAGE_DIR
restorecon -v $IMAGE_DIR
chattr +C $IMAGE_DIR


