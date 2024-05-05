#! /bin/sh
#

base_path="$(pwd)"

# The example names get mapped to their roles here
orig_iso=${base_path}$1
new_files=${base_path}$2
new_iso=${base_path}$3
mbr_template=isohdpfx.bin

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

