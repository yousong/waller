#
# Copyright (C) 2008-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ttdnsd
PKG_VERSION:=0.7
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://www.torproject.org/dist/misc/ttdnsd
PKG_MD5SUM:=5e964e019b3024cbff15d011071a6772
PKG_MAINTAINER:="Yousong Zhou <yszhou4tech@gmail.com>"
PKG_LICENSE:=

#PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/ttdnsd
  SECTION:=net
  CATEGORY:=Network
  URL:=http://www.mulliner.org/collin/ttdnsd.php
  TITLE:=A forwarding nameserver that also bridges between UDP and TCP
endef

define Package/ttdnsd/description
 ttdnsd accepts DNS requests via UDP and forwards the to a resolving nameserver
 via TCP.
endef

define Package/ttdnsd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ttdnsd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/ttdnsd.init $(1)/etc/init.d/ttdnsd
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/ttdnsd.config $(1)/etc/config/ttdnsd
endef

define Build/Compile
$(call Build/Compile/Default,notsocks)
endef

$(eval $(call BuildPackage,ttdnsd))
