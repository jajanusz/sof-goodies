# Support for 32bit linux libraries in WSL

## Enable 32bit binaries

Install qemu that will run 32 bit binaries and register it
```
sudo apt update
sudo apt install qemu-user-static
sudo update-binfmts --install i386 /usr/bin/qemu-i386-static --magic '\x7fELF\x01\x01\x01\x03\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x03\x00\x01\x00\x00\x00' --mask '\xff\xff\xff\xff\xff\xff\xff\xfc\xff\xff\xff\xff\xff\xff\xff\xff\xf8\xff\xff\xff\xff\xff\xff\xff'
```

Start service that enables support for 32bit, do it now and **every time** that you want to enable 32 bit support (or just add it to startup scripts if you want to have it enabled on every WSL launch).
```
sudo service binfmt-support start
```

Add i386 arch for dpkg and install packages needed by most of apps.
```
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y libc6:i386 libncurses5:i386 libstdc++6:i386 zlib1g:i386 zlib1g-dev:i386
```

## Fix stat in 32bit binaries

Many of 32bit apps cannot handle 64bit inodes of WSL filesystems.
We can replace stat() with function that will partially support 64bit inodes by at least giving file properties (for example it will return EOVERFLOW for file size >= 2^32, but at least struct with properties will have some info).

Clone this repo and go to **wsl_32bit_support** folder.
First you need to build shared libs with changed stat that we will use for preload:
```
./build.sh
```
Next we have to put these libs in appropriate folders, so ld will pickup 64b lib for 64bit apps and 32b lib with fixed stat for 32bit apps:
```
sudo ./install.sh
```

Then you have to add our libs to LD_PRELOAD **every time** you want 32bit binaries to use changed stat:
```
export LD_PRELOAD=inode64.so
```
