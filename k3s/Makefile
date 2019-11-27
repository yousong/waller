#
# Copyright (C) 2019 Yousong Zhou <yszhou4tech@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

k3s_version:=0.8.1
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
    FILE:=$(k3s_$(1)_bin)
    HASH:=$(k3s_$(1)_hash)
  endef
endef

k3s_amd64_bin:=k3s
k3s_amd64_hash:=5bfe6a1299f26969a257ca877db940b640b1b29f670337338b7d81112e061590
k3s_arm64_bin:=k3s-arm64
k3s_arm64_hash:=d5512876b2ee01bd98247b329f3e715b2c67096cf828be71aa99835e0ca5561f
k3s_armhf_bin:=k3s-armhf
k3s_armhf_hash:=65c0d066f5aef6d100f6f60b395199a0d0079775934750179f20efdd997119dc

$(eval $(call K3S/Download,amd64))
$(eval $(call Download,k3s-amd64))

ifeq ($(ARCH),x86_64)
  k3s_arch:=amd64
else ifeq ($(ARCH),aarch64)
  k3s_arch:=arm64
else
  k3s_arch:=armhf
endif

k3s_bin:=$(k3s_$(k3s_arch)_bin)

define Package/k3s
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Lightweight Kubernetes. 5 less than k8s.
  URL:=https://k3s.io
  DEPENDS:=@(x86_64||aarch64||TARGET_sunxi) \
	  +kmod-br-netfilter \
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
