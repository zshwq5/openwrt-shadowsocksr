include $(TOPDIR)/rules.mk

PKG_NAME:=shadowsocksR-libev
PKG_VERSION:=2.5.6
#PKG_VERSION:=20170520
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_SOURCE_URL:=https://github.com/shadowsocksr/shadowsocksr-libev.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=39ec29efede90edcd095596dead3692ea3ad7491
#PKG_SOURCE_VERSION:=981037a05d2b677d02255a3f3bb1129ab4bc015e
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_MAINTAINER:=breakwa11

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)

PKG_INSTALL:=1
PKG_FIXUP:=autoreconf
PKG_USE_MIPS16:=0
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/shadowsocksr-libev/Default
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Lightweight Secured Socks5 Proxy
  URL:=https://github.com/shadowsocksr/shadowsocksr-libev
endef

define Package/shadowsocksr-libev
  $(call Package/shadowsocksr-libev/Default)
  TITLE+= (OpenSSL)
  VARIANT:=openssl
  DEPENDS:=+libopenssl +libpcre +libpthread +zlib
endef

define Package/shadowsocksr-libev-polarssl
  $(call Package/shadowsocksr-libev/Default)
  TITLE+= (PolarSSL)
  VARIANT:=polarssl
  DEPENDS:=+libpolarssl +libpthread +libpcre
endef


define Package/shadowsocksr-libev-server
  $(call Package/shadowsocksr-libev/Default)
  TITLE+= (OpenSSL)
  VARIANT:=openssl
  DEPENDS:=+libopenssl +libpthread +libpcre
endef

define Package/shadowsocksr-libev-server-polarssl
  $(call Package/shadowsocksr-libev/Default)
  TITLE+= (PolarSSL)
  VARIANT:=polarssl
  DEPENDS:=+libpolarssl +libpthread +libpcre
endef

define Package/shadowsocksr-libev/description
ShadowsocksR-libev is a lightweight secured socks5 proxy for embedded devices and low end boxes.
endef

Package/shadowsocksr-libev-polarssl/description=$(Package/shadowsocksr-libev/description)
Package/shadowsocksr-libev-server/description=$(Package/shadowsocksr-libev/description)
Package/shadowsocksr-libev-server-polarssl/description=$(Package/shadowsocksr-libev/description)

define Package/shadowsocksr-libev/conffiles
/etc/shadowsocksr.json
endef

Package/shadowsocksr-libev-polarssl/conffiles = $(Package/shadowsocksr-libev/conffiles)


define Package/shadowsocksr-libev-server/conffiles
/etc/shadowsocksr-server.json
endef

Package/shadowsocksr-libev-server-polarssl/conffiles = $(Package/shadowsocksr-libev-server/conffiles)


CONFIGURE_ARGS += --disable-ssp

ifeq ($(BUILD_VARIANT),polarssl)
	CONFIGURE_ARGS += --with-crypto-library=polarssl
endif

define Package/shadowsocksr-libev/install
	$(INSTALL_DIR) $(1)/etc/init.d
	#$(INSTALL_BIN) ./files/shadowsocksr $(1)/etc/init.d/shadowsocksr
	$(INSTALL_CONF) ./files/shadowsocksr.json $(1)/etc/shadowsocksr.json
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-local $(1)/usr/bin/ssr-local
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-redir $(1)/usr/bin/ssr-redir
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-tunnel $(1)/usr/bin/ssr-tunnel
endef

Package/shadowsocksr-libev-polarssl/install=$(Package/shadowsocksr-libev/install)


define Package/shadowsocksr-libev-server/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_CONF) ./files/shadowsocksr-server.json $(1)/etc/shadowsocksr-server.json
	#$(INSTALL_BIN) ./files/shadowsocksr-server $(1)/etc/init.d/shadowsocksr-server
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/ss-server $(1)/usr/bin/ssr-server
endef

Package/shadowsocksr-libev-server-polarssl/install=$(Package/shadowsocksr-libev-server/install)

$(eval $(call BuildPackage,shadowsocksr-libev))
$(eval $(call BuildPackage,shadowsocksr-libev-polarssl))
$(eval $(call BuildPackage,shadowsocksr-libev-server))
$(eval $(call BuildPackage,shadowsocksr-libev-server-polarssl))
