#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocks-libev
PKG_VERSION:=2.4.5
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/shadowsocks/shadowsocks-libev.git
PKG_SOURCE_VERSION:=3a0c6a19191b38e928f7932a926524e376970571
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_MAINTAINER:=Yousong Zhou <yszhou4tech@gmail.com>

PKG_LICENSE:=GPL-3.0+
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)
PKG_FIXUP:=autoreconf
PKG_INSTALL:=1
PKG_USE_MIPS16:=0

include $(INCLUDE_DIR)/package.mk


define Package/shadowsocks-libev-config
  SECTION:=net
  CATEGORY:=Network
  TITLE:=shadowsocks-libev config scripts
  URL:=https://github.com/shadowsocks/shadowsocks-libev
endef

define Package/shadowsocks-libev-config/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/shadowsocks-libev.config $(1)/etc/config/shadowsocks-libev
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/shadowsocks-libev.init $(1)/etc/init.d/shadowsocks-libev
endef

ifeq ($(BUILD_VARIANT),libpolarssl)
CONFIGURE_ARGS += --with-crypto-library=polarssl
endif

define Package/shadowsocks-libev/Default
  define Package/shadowsocks-libev-$(1)-$(2)
    SECTION:=net
    CATEGORY:=Network
    TITLE:=shadowsocks-libev $(2) with $(1)
    URL:=https://github.com/shadowsocks/shadowsocks-libev
    DEPENDS:=$(3) +libpthread +shadowsocks-libev-config
    VARIANT:=$(1)
  endef
endef

define Package/shadowsocks-libev/install/Default
  define Package/shadowsocks-libev-$(1)-$(2)/install
	$$(INSTALL_DIR) $$(1)/usr/bin
	$$(INSTALL_BIN) $$(PKG_INSTALL_DIR)/usr/bin/$(2) $$(1)/usr/bin
  endef
endef

SHADOWSOCKS_VARIANTS:=libopenssl libpolarssl
SHADOWSOCKS_COMPONENTS:=ss-local ss-redir ss-tunnel ss-server ss-manager
define shadowsocks-libev/templates
  $(foreach variant,$(SHADOWSOCKS_VARIANTS),
    $(foreach component,$(SHADOWSOCKS_COMPONENTS),
      $(call Package/shadowsocks-libev/Default,$(variant),$(component),+$(variant))
      $(call Package/shadowsocks-libev/install/Default,$(variant),$(component))
    )
  )
endef

$(eval $(call shadowsocks-libev/templates))
$(eval $(call BuildPackage,shadowsocks-libev-config))
$(foreach variant,$(SHADOWSOCKS_VARIANTS), \
  $(foreach component,$(SHADOWSOCKS_COMPONENTS), \
    $(eval $(call BuildPackage,shadowsocks-libev-$(variant)-$(component))) \
  ) \
)
