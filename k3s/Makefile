#
# Copyright (C) 2019 Yousong Zhou <yszhou4tech@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

k3s_version:=1.0.0
k3s_dl_url:=https://github.com/rancher/k3s/releases/download/v$(k3s_version)

PKG_NAME:=k3s
PKG_VERSION:=$(k3s_version)
PKG_RELEASE:=1
PKG_LICENSE:=Apache-2.0

PKG_MAINTAINER:=Yousong Zhou <yszhou4tech@gmail.com>

include $(INCLUDE_DIR)/package.mk

define K3S/Download
  define Download/k3s-$(1)
    URL:=$(k3s_dl_url)
    URL_FILE:=$(k3s_$(1)_bin)
    FILE:=$(k3s_$(1)_bin)-$(k3s_version)
    HASH:=$(k3s_$(1)_hash)
  endef
endef

k3s_amd64_bin:=k3s
k3s_arm64_bin:=k3s-arm64
k3s_armhf_bin:=k3s-armhf
k3s_amd64_hash:=33fa658ab8d0e2c54c761aa93ac0d1156870fbbc67fb904739ca3d6deb0672a9
k3s_arm64_hash:=e3c5658d97f290394c57a936027418c8662ebcc2ad721110dccdc4375c6d0607
k3s_armhf_hash:=30cc1a1608c4b34c8c86f5db54bdb1da6713658981893ee18610ce170b8a12dd

ifeq ($(ARCH),x86_64)
  k3s_arch:=amd64
else ifeq ($(ARCH),aarch64)
  k3s_arch:=arm64
else
  k3s_arch:=armhf
endif

k3s_bin:=$(k3s_$(k3s_arch)_bin)-$(k3s_version)

$(eval $(call K3S/Download,$(k3s_arch)))
$(eval $(call Download,k3s-$(k3s_arch)))

define Package/k3s
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Lightweight Kubernetes. 5 less than k8s.
  URL:=https://k3s.io
  DEPENDS:=@(x86_64||aarch64||TARGET_sunxi||TARGET_armvirt) \
	  +kmod-br-netfilter \
	  +kmod-ipt-ipset \
	  +kmod-nf-ipvs \
	  +kmod-nf-conntrack-netlink \
	  +kmod-veth \
	  +kmod-vxlan \
	  +ca-certificates \
	  +cgroupfs-mount \
	  +iptables-mod-extra \

endef

define Package/k3s/config
config k3s_KERNEL
	bool "Enable kernel features required for k3s"
	default n
	select KERNEL_CGROUPS
	select KERNEL_KEYS
	select KERNEL_MEMCG
	select KERNEL_NAMESPACES
	select KERNEL_SECCOMP
	select KERNEL_SECCOMP_FILTER
	select KERNEL_X86_VSYSCALL_EMULATION if x86_64

endef

define Package/k3s/install
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_BIN) $(DL_DIR)/$(k3s_bin) $(1)/usr/sbin/k3s
endef

Build/Compile:=

$(eval $(call BuildPackage,k3s))
