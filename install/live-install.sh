#!/bin/sh
set -e
export root_password
export user_name
export user_password
export host_name

boot_name="boot"
swap_name="swap"
root_name="arch"

boot_start="1"
boot_end="512"

update_system_clock() {
  grep -i "Finished update_system_clock()" log > /dev/null && return

  timedatectl set-ntp true

  echo "Finished update_system_clock()" >> log
}

partition_disk() {
  boot_end+="MB"
  swap_start+="MB"
  swap_end+="MB"

  if ! grep -i "Finished partition_disk()" log > /dev/null; then
    parted -s "$installation_disk"                                  \
      mklabel gpt                                                   \
      mkpart "$boot_name" fat32 "$boot_start" "$boot_end"           \
      set 1 boot on                                                 \
      mkpart "$swap_name" "linux-swap(v1)" "$boot_end" "$swap_size" \
      mkpart "$root_name" ext4 "$swap_end" 100%
  fi


  partitions=$(fdisk -l | grep "^$installation_disk")
  boot_partition=$( echo "$partitions" | grep "EFI System" | awk '{ printf $1}')
  swap_partition=$( echo "$partitions" | grep "Linux swap" | awk '{ printf $1 }')
  root_partition=$( echo "$partitions" | grep "Linux filesystem" | awk '{ printf $1 }')

  echo "Finished partition_disk()" >> log
}

format_partitions() {
  grep -i "Finished format_partitions()" log > /dev/null && return

  mkfs.ext4 "$root_partition"
  mkswap "$swap_partition"
  mkfs.fat -F 32 "$boot_partition"

  echo "Finished format_partitions()" >> log
}

mount_partitions() {
  grep -i "Finished mount_partitions()" log > /dev/null && return

  mount "$root_partition" /mnt
  mount --mkdir "$boot_partition" /mnt/boot
  swapon "$swap_partition"


  hdd_path=$(fdisk -l | grep -B 1 "ST2000DM008-2FR1" | sed 1q | awk -F ":| " '{ printf $2 }')
  if [ -n "$hdd_path" ]; then
    linux_hdd_part= "$(fdisk -x | grep "Linux" | awk '{print $1}')"
    mount "$linux_hdd_part" /mnt/mnt/linuxHDD
  fi

  echo "Finished mount_partitions()" >> log
}

fstab() {
  grep -i "Finished fstab()" log > /dev/null && return

  genfstab -U /mnt >> /mnt/etc/fstab

  echo "Finished fstab()" >> log
}

install_packages() {
  grep -i "Finished install_packages()" log > /dev/null && return

  arch-chroot /mnt bash -c "pacman -S --noconfirm --needed - < /install_tmp/packages.txt"

  echo "Finished install_packages()" >> log
}

main() {
  touch log

  # Get disk to be installed on
  while true; do
    disks=$(fdisk -l)
    echo "$disks"
    printf "Type path of disk to install --> "
    read -r installation_disk

    disks=$(echo "$disks" | grep -i "Disk /dev/" | awk -F ":| " '{print $2}' | grep -i "$installation_disk")
    if [ "$disks" = "$installation_disk" ]; then
      printf "You chose %s. Confirm ? Y/n\n" "$installation_disk"
      fdisk -l "$installation_disk" | sed '2!d'
      read -r disk_answer
      
      if [ "$disk_answer" = "y" ] || [ "$disk_answer" = "Y" ]; then
        break
      fi
    fi
  done

  # Get ram size and set swap_size
  while true; do
    free -h
    printf "Choose size of swap in GB --> "
    read -r swap_size
    
    printf "Swap size is %sGB. Confirm ? Y/n " "$swap_size"
    read -r swap_answer
    if [ "$swap_answer" = "y" ] || [ "$swap_answer" = "Y" ]; then
      # Convert to MB
      swap_size=$(( "$swap_size" * 1024))

      swap_start=$(( "$boot_end" ))
      swap_end=$(( "$boot_end" + "$swap_size"))
      break
    fi
  done

  # Get root password
  while true; do
    printf "\n\n"
    printf "Choose root password --> "
    read -r root_password

    printf "Confirm root password --> "
    read -r second_root_password

    if [ "$root_password" != "$second_root_password" ]; then
      printf "Root passwords don't match."
      continue
    fi

    printf "%s. Confirm password ? Y/n " "$root_password"
    read -r answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
      break
    fi
  done

  # Get user name
  while true; do
    printf "\n\n"
    printf "Choose user name --> "
    read -r user_name
    printf "%s. Confirm name ? Y/n " "$user_name"
    read -r answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
      break
    fi
  done

  # Get user password
  while true; do
    printf "\n\n"
    printf "Choose user password --> "
    read -r user_password

    printf "Confirm user password --> "
    read -r second_user_password

    if [ "$user_password" != "$second_user_password" ]; then
      printf "User passwords don't match."
      continue
    fi

    printf "%s. Confirm password ? Y/n " "$user_password"
    read -r answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
      break
    fi
  done

  # Get hostname
  while true; do
    printf "\n\n"
    printf "Choose host name --> "
    read -r host_name

    printf "%s. Confirm hostname ? Y/n " "$host_name"
    read -r answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
      break
    fi
  done

  update_system_clock
  partition_disk
  format_partitions
  mount_partitions
  sed -i "s|#ParallelDownloads = 5|ParallelDownloads = 6|g" /etc/pacman.conf
  pacstrap /mnt base base-devel linux linux-firmware
  fstab

  # Save vars to use in config script
  mkdir -p /mnt/install_tmp
  cp packages.txt  \
  config-system.sh \
  config-user.sh \
  -t /mnt/install_tmp

  sed -i "s|#ParallelDownloads = 5|ParallelDownloads = 6|g" /mnt/etc/pacman.conf
  install_packages
  arch-chroot /mnt bash -c "/install_tmp/config-system.sh"
  arch-chroot /mnt bash -c "su "$user_name" -c /install_tmp/config-user.sh"

  rm -rf /mnt/install_tmp

  printf "System installed and configured.\n"
}

main
