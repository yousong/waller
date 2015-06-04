include $(TOPDIR)/rules.mk

PKG_NAME:=osocks
PKG_VERSION:=2015-06-03
PKG_RELEASE=$(PKG_SOURCE_VERSION)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git://github.com/yousong/osocks.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=9ab92f9838fbc0b2b044f3dd08997e8414020dd6
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
CMAKE_INSTALL:=1
PKG_CHECK_FORMAT_SECURITY:=0

PKG_MAINTAINER:=Yousong Zhou <yszhou4tech@gmail.com>

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/osocks
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+libubox
  URL:=https://github.com/yousong/osocks
  TITLE:=A small dumb SOCKSv5 server doing epoll/kqueue with `libubox` of OpenWrt
endef

define Package/osocks/description
 `osocks` is a small dumb SOCKSv5 server doing epoll/kqueue with `libubox` of OpenWrt.
endef

define Package/osocks/install
	$(INSTALL_DIR) $(1)/usr/sbin $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/osocks $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/osocks.init $(1)/etc/init.d/osocks
	$(INSTALL_DATA) ./files/osocks.config $(1)/etc/config/osocks
endef

$(eval $(call BuildPackage,osocks))
