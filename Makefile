
.PHONY: deps profile archiso apply

deps:
	sudo pacman --needed -Sy archiso squashfs-tools cdrtools xorriso mtools

# profile:
# 	rm -rf ./profile
# 	cp -r /usr/share/archiso/configs/releng/ ./profile

archiso:
	cp ~/.ssh/id_ed25519_github_efosmark ./profile/airootfs/root/.ssh/id_ed25519_github_efosmark
	sudo mkarchiso -v -w $(shell mktemp -d) -o ./ ./profile

apply:
	rsync -a liveroot/ profile/airootfs/



#### OLD STUFF BEYOND THIS POINT


.PHONY: deps uniso unsfs geniso airootfs mkcert signsfs

# deps:
#        sudo pacman --needed -Sy squashfs-tools cdrtools xorriso syslinux

# geniso:
#         sudo xorriso -as mkisofs \
#           -iso-level 3 \
#           -full-iso9660-filenames \
#           -volid "ARCH_LINUX" \
#           -eltorito-boot boot/syslinux/isolinux.bin \
#           -eltorito-catalog boot/syslinux/boot.cat \
#           -no-emul-boot -boot-load-size 4 -boot-info-table \
#           -eltorito-alt-boot -e EFI/BOOT/BOOTx64.EFI -no-emul-boot \
#           -isohybrid-mbr ./archiso-working/boot/syslinux/isohdpfx.bin \
#           -output archiso.iso ./archiso-working

# archiso: airootfs signsfs geniso

# uniso:
#         rm -rf /tmp/archiso
#         mkdir /tmp/archiso
#         sudo mount -o loop archlinux.iso /tmp/archiso
#         mkdir -p ./archiso-working
#         cp -rT /tmp/archiso ./archiso-working
#         sudo umount /tmp/archiso

# unsfs:
#         sudo unsquashfs -d ./airootfs ./archiso-working/arch/boot/airootfs.sfs

# airootfs:
#         @sudo rm -f ./archiso-working/arch/x86_64/airootfs.sfs
#         sudo mksquashfs \
#                 ./airootfs \
#                 ./archiso-working/arch/x86_64/airootfs.sfs \
#                 -comp xz
#         @sha512sum ./archiso-working/arch/x86_64/airootfs.sfs \
#         | sudo tee ./archiso-working/arch/x86_64/airootfs.sha512

# mkcert:
#         openssl genpkey -algorithm RSA -out private_key.pem -aes256
#         openssl req -new -x509 -key private_key.pem -out certificate.pem -days 365

# signsfs:
#         @sudo rm -f ./archiso-working/arch/x86_64/airootfs.sfs.cms.sig
#         sudo openssl cms -sign \
#                 -in      ./archiso-working/arch/x86_64/airootfs.sfs \
#                 -signer  certificate.pem \
#                 -inkey   private_key.pem \
#                 -outform DER \
#                 -out     ./archiso-working/arch/x86_64/airootfs.sfs.cms.sig