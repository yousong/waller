# Copyright (C) 2015 Yousong Zhou

include $(TOPDIR)/rules.mk

PKG_NAME:=ossherd
PKG_VERSION:=2015-06-10
PKG_RELEASE=1

PKG_MAINTAINER:=Yousong Zhou <yszhou4tech@gmail.com>

include $(INCLUDE_DIR)/package.mk

define Package/ossherd
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+openssh-client +redsocks +iptables-mod-conntrack-extra
  TITLE:=A service for running redsocks with multiple SSH SOCKS5 proxies
endef

define Package/ossherd/description
  A service for running redsocks with multiple SSH SOCKS5 proxies
endef

define Build/Compile
endef

define Package/ossherd/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_BIN) ./files/ossherd-askpass $(1)/usr/bin/ossherd-askpass
	$(INSTALL_BIN) ./files/ossherd.init $(1)/etc/init.d/ossherd
	$(INSTALL_DATA) ./files/firewall.ossherd $(1)/etc/firewall.ossherd
	$(INSTALL_DATA) ./files/ossherd.config $(1)/etc/config/ossherd
endef

$(eval $(call BuildPackage,ossherd))
