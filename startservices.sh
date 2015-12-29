  #Get docker env timezone and set system timezone
  echo "setting the correct local time"
  echo $TZ > /etc/timezone
  export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive
  dpkg-reconfigure tzdata
  
  #fix memory issue
  echo "increasing shared memory"
  umount /dev/shm
  mount -t tmpfs -o rw,nosuid,nodev,noexec,relatime,size=${MEM:-4096M} tmpfs /dev/shm
  
  echo "starting services"
  service mysql start
  service apache2 start
  service zoneminder start
