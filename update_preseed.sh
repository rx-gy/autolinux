#! /bin/sh
#


localpath="$(pwd)"

# The example names get mapped to their roles here
orig_iso=${localpath}/$1
new_files=${localpath}/$2
new_iso=${localpath}/$3
orig_iso=${localpath}/netboot/mini.iso
new_files=${localpath}/isofiles
new_iso=${localpath}/debsid.iso
mbr_template=isohdpfx.bin
initrd=${new_files}/initrd


rm  $mbr_template
rm -r $new_files
rm  $new_iso


# check we have latest mini.iso
rm MD5SUMS
wget https://d-i.debian.org/daily-images/amd64/daily/MD5SUMS
if md5sum -c MD5SUMS --ignore-missing ;
then
	echo "mini.iso is up to date"
else
	echo "getting most recent mini.iso"
	rm netboot/mini.iso
	wget https://d-i.debian.org/daily-images/amd64/daily/netboot/mini.iso --directory-prefix=netboot/
fi

if md5sum -c MD5SUMS --ignore-missing
then
	echo "mini.iso is good"
else
	echo "failed checksum"
	exit
fi

# Unpack originals
7z x -y netboot/mini.iso -o$(basename $new_files)
gunzip ${initrd}.gz

echo preseed.cfg | cpio -H newc -o -A -F $initrd
echo ansible.service | cpio -H newc -o -A -F $initrd
echo vault_pass | cpio -H newc -o -A -F $initrd

gzip ${initrd}

cp splash.png ${new_files}/splash.png

# Extract MBR template file to disk
dd if="$orig_iso" bs=1 count=432 of="$mbr_template"


# Create the new ISO image
xorriso -as mkisofs \
   -r -V 'Debian 9.3.0 amd64 n' \
   -o "$new_iso" \
   -J -J -joliet-long -cache-inodes \
   -isohybrid-mbr "$mbr_template" \
   -b isolinux.bin \
   -c boot.cat \
   -boot-load-size 4 -boot-info-table -no-emul-boot \
   -eltorito-alt-boot \
   -e boot/grub/efi.img \
   -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus \
   "$new_files"

rm -rf $new_files
