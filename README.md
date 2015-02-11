This is an OpenWrt package feeds.

To use it, add the following line to `feeds.conf` which is at the root of OpenWrt source tree.

	src-git waller git://github.com/yousong/waller.git

Update the feeds.

	./scripts/feeds update waller

Activate packages in feeds

	./scripts/feeds install -a -p waller

Select what you want to include in the final image in `make menuconfig`.
