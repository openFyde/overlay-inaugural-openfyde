#!/bin/bash
part_num=$1
disk_dev=$2
kernelA=2
kernelB=4
rootA=3
rootB=5
boot_b_file="boot/first-b.txt"
EFI_NUM=12

get_part_priority() {
  local part_num=$1
  cgpt show -i $part_num -P $disk_dev
}

determin_root_num() {
  local priorityA=$(get_part_priority $kernelA)
  local priorityB=$(get_part_priority $kernelB)
  if [ "$priorityA" -ge "$priorityB" ]; then
    echo $rootA
  else
    echo $rootB
  fi
}

help() {
  echo "$0 [root_partition_num] [disk_dev]"
  echo "example 1: $0 3 /dev/sda :means load /dev/sda3 as root at next booting"
  echo "example 2: $0 3 :means load current device partition 3 as root at next booting"
  echo "example 3: $0 :means switch rootfs by ChromeOS rules "
}

die() {
  echo $@
  help
  exit 1
}

get_uuid() {
  local part_num=$1
  local disk_dev=$2
  cgpt show -i $part_num -u $disk_dev
}

check_var() {
  local part_num=$1
  local disk_dev=$2
  if [ -z "$part_num" ]; then
    die "need one part_num."
  fi
  if [ ! -b ${disk_dev} ]; then
    die "${disk_dev} does not exist!"
  fi
  cgpt add -t kernel -i 2 $disk_dev
  cgpt add -t kernel -i 4 $disk_dev
  get_uuid $part_num $disk_dev 2>&1 1>/dev/null || die "Can not get real partition uuid"
}

modify_root() {
  local cmdfile=$1
  local root_uuid=$2
  sed -i "s|[[:alnum:]]*-[[:alnum:]]*-[[:alnum:]]*-[[:alnum:]]*-[[:alnum:]]*|${root_uuid}|g" $cmdfile
  sync $cmdfile
}

change_boot_to() {
  local boot_to_part_num=$1
  local efi_mnt=$2
  local boot_b="$efi_mnt/${boot_b_file}"
  if [ $boot_to_part_num == "$rootA" ]; then
    [ -f $boot_b ] && rm $boot_b
  else
    touch $boot_b
  fi
}

main() {
 local part_num=$1
 local disk_dev=$2

 # main $@ consumed the first empty arg
 if [ "$#" -eq 1 ]; then
   disk_dev=$1
   part_num=""
 fi

 if [ "$part_num" != "$rootA" ] && [ "$part_num" != "$rootB" ]; then
   part_num=""
 fi

 [ -z "${disk_dev}" ] && disk_dev=$(rootdev -d)
 [ -z "${part_num}" ] && part_num=$(determin_root_num)
 check_var $part_num $disk_dev
 local tmpdir=$(mktemp -d)
 local efi_dev=
 if [[ $disk_dev =~ [a-z]$ ]]; then
   efi_dev=${disk_dev}${EFI_NUM}
 else
   efi_dev=${disk_dev}p${EFI_NUM}
 fi
 local root_dev=
 if [[ $disk_dev =~ [a-z]$ ]]; then
   root_dev=${disk_dev}${part_num}
 else
   root_dev=${disk_dev}p${part_num}
 fi
 mount $efi_dev $tmpdir || die "error mounting"
 change_boot_to $part_num $tmpdir
 umount $tmpdir
 rmdir $tmpdir
}

main $@
