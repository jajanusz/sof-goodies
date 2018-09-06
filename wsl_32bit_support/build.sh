#!/bin/sh

# info for ld

cat > vers <<EOC
GLIBC_2.0 {
  global:
    readdir;
    __fxstat;
    __xstat;
    __lxstat;
};
EOC

# build fixed stat for 32bit apps

gcc -c -fPIC -m32 -fno-stack-protector inode64.c
mkdir -p b32
ld -shared -melf_i386 --version-script vers -o b32/inode64.so inode64.o

# build empty lib that does nothing for 64bit apps

mkdir -p b64
echo "" | gcc -xc -fPIC -shared -o b64/inode64.so -

