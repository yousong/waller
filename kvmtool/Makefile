#
# Copyright (C) 2016 Yousong Zhou <yszhou4tech@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=kvmtool

PKG_SOURCE_VERSION:=b09224228296d9febf120f3aa956964cc01a14b5
PKG_VERSION:=2016-11-28-$(PKG_SOURCE_VERSION)
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)
PKG_SOURCE_URL:=https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=COPYING
PKG_INSTALL:=1
PKG_MAINTAINER:=Yousong Zhou <yszhou4tech@gmail.com>

include $(INCLUDE_DIR)/package.mk

define Package/kvmtool
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Native Linux KVM tool
  URL:=http://www.qemu.org
  DEPENDS:=@(arm||x86_64) +arm:libfdt
endef

define Package/kvmtool/description
  kvmtool is a lightweight tool for hosting KVM guests. As a pure virtualization
  tool it only supports guests using the same architecture, though it supports
  running 32-bit guests on those 64-bit architectures that allow this.
endef

define Package/kvmtool/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/bin/lkvm $(1)/usr/bin
endef

MAKE_VARS += ARCH=$(ARCH)
MAKE_FLAGS := $(filter-out ARCH=%,$(MAKE_FLAGS))
MAKE_FLAGS += \
	prefix=	\

KVMTOOL_FEATURES_off := \
	BFD \
	GTK3 \
	VNCSERVER \
	SDL \
	ZLIB \
	AIO \

MAKE_FLAGS += $(foreach v,$(KVMTOOL_FEATURES_off),SOURCE_$(v)="\#error $(v) disabled")

$(eval $(call BuildPackage,kvmtool))
