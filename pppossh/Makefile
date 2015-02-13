#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=pppossh
PKG_RELEASE:=1
PKG_MAINTAINER:=Yousong Zhou <yszhou4tech@gmail.com>

include $(INCLUDE_DIR)/package.mk

define Package/pppossh
  SECTION:=net
  CATEGORY:=Network
  TITLE:=PPPoSSH (Point-to-Point Protocol over SSH)
  URL:=https://github.com/yousong/waller
  DEPENDS:=+ppp +resolveip @(PACKAGE_dropbear||PACKAGE_openssh-client)
endef

define Package/pppossh/description
This package adds protocol support for PPP over SSH.  The protocol name is
'pppossh' with the following options.

- `server`, SSH server name (*required*).
- `port`, SSH server port (defaults to `22`).
- `sshuser`, SSH login username (*required*).
- `identity`, list of client private key files.  `~/.ssh/id_{rsa,dsa}` will
   be used if no identity file was specified and at least one of them must be
   valid for the public key authentication to proceed.
- `ipaddr`, local ip address to be assigned.
- `peeraddr`, peer ip address to be assigned.
- `ssh_options`, extra options for the ssh client.
endef

define Build/Compile
endef

define Package/pppossh/install
	$(INSTALL_DIR) $(1)/lib/netifd/proto
	$(INSTALL_BIN) ./files/pppossh.sh $(1)/lib/netifd/proto
endef

$(eval $(call BuildPackage,pppossh))
