include $(TOPDIR)/rules.mk

PKG_NAME:=utdnsd
PKG_VERSION:=2016-03-08
PKG_RELEASE:=2

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/yousong/utdnsd.git
PKG_SOURCE_VERSION:=8e9bd5bd46d0816978749f6193da066489bb737c
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.gz
PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)
CMAKE_INSTALL:=1
PKG_CHECK_FORMAT_SECURITY:=0

PKG_MAINTAINER:=Yousong Zhou <yszhou4tech@gmail.com>

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/utdnsd
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+libubox
  URL:=https://github.com/yousong/utdnsd
  TITLE:=A DNS forwarder serving UDP requests by doing lookup in TCP.
endef

define Package/utdnsd/description
 utdnsd is a non-caching DNS forwarder serving requests from UDP transport by delegating them to upstream DNS servers with TCP.
endef

define Package/utdnsd/install
	$(INSTALL_DIR) $(1)/usr/sbin $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/utdnsd $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/utdnsd.init $(1)/etc/init.d/utdnsd
	$(INSTALL_DATA) ./files/utdnsd.config $(1)/etc/config/utdnsd
endef

$(eval $(call BuildPackage,utdnsd))
