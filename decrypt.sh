#!/bin/sh

# Place where wrapped-passphrase and Private.sig stored
ECRYPT_HOME=/home/$USER/.ecryptfs 
# directory where decrypted content will be showing up
TARGET=/home/kandaurov/Downloads/test
# directory for encrypted content
SOURCE=/home/kandaurov/Downloads/.test

sudo mkdir -p $TARGET
cd $ECRYPT_HOME
echo Unwrapping passphrase using your password
echo Type your password:
PASS=$(ecryptfs-unwrap-passphrase wrapped-passphrase | sed s/Passphrase:\ //)
echo Passphrase:
echo $PASS\n

echo Getting signatures
SIG1=$(head -n1 Private.sig)
SIG2=$(tail -n1 Private.sig)
echo Signatures:
echo $SIG1
echo $SIG2\n

echo Should be empty:
sudo keyctl clear @u
sudo keyctl list @u

echo Do not type anything:
echo $PASS | sudo ecryptfs-add-passphrase --fnek

echo Sould have signatures:
sudo keyctl list @u

echo Mounting $SOURCE on $TARGET...
sudo mount -t ecryptfs -o key=passphrase,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_passthrough=no,ecryptfs_enable_filename_crypto=yes,ecryptfs_sig=$SIG1,ecryptfs_fnek_sig=$SIG2,passwd=$(echo $PASS) $SOURCE $TARGET

cd $TARGET
ls -al $TARGET