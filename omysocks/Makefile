# Copyright (C) 2015-2017 Yousong Zhou

include $(TOPDIR)/rules.mk

PKG_NAME:=omysocks
PKG_VERSION:=2017-05-01
PKG_RELEASE=1

PKG_MAINTAINER:=Yousong Zhou <yszhou4tech@gmail.com>

include $(INCLUDE_DIR)/package.mk

define Package/omysocks
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+openssh-client +redsocks +iptables-mod-conntrack-extra
  TITLE:=A service for running redsocks with multiple SSH SOCKS5 proxies
endef

define Package/omysocks/description
  A service for running redsocks with multiple SOCKS5 proxies of both
  SSH-initiated or raw ones
endef

define Build/Compile
endef

define Package/omysocks/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_BIN) ./files/omysocks-askpass $(1)/usr/bin/omysocks-askpass
	$(INSTALL_BIN) ./files/omysocks.init $(1)/etc/init.d/omysocks
	$(INSTALL_DATA) ./files/firewall.omysocks $(1)/etc/firewall.omysocks
	$(INSTALL_DATA) ./files/omysocks.config $(1)/etc/config/omysocks
endef

$(eval $(call BuildPackage,omysocks))
