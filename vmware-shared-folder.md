[How to configure VMware Tools Shared Folders Linux mounts (60262)](https://kb.vmware.com/s/article/60262)

`sudo apt-get -y install open-vm-tools-desktop` \
`vmtoolsd --version` \
`ps aux | grep "vmtoolsd"` \
`df -kh` \
`vmware-hgfsclient` \
`sudo gedit /etc/fstab`

    vmhgfs-fuse                               /mnt/hgfs       fuse    defaults,allow_other  0       0
`sudo mount -a`

