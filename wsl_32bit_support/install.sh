# ld will pickup 64b lib for 64bit apps and 32b lib with fixed stat for 32bit apps

cp b64/inode64.so /lib/x86_64-linux-gnu/inode64.so
cp b32/inode64.so /lib/inode64.so

