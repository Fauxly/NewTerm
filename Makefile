export TARGET = iphone:clang:latest:15.0
export ARCHS = arm64

export INSTALL_PREFIX =
export DEB_ARCH = appletvos-arm64

INSTALL_TARGET_PROCESSES = NewTerm

include $(THEOS)/makefiles/common.mk

XCODEPROJ_NAME = NewTerm

# Используем существующую scheme
NewTerm_XCODE_SCHEME = NewTerm

# Передаём install prefix
NewTerm_XCODEFLAGS = INSTALL_PREFIX=$(INSTALL_PREFIX)

# Entitlements
NewTerm_CODESIGN_FLAGS = -SApp/entitlements.plist

# Rootful install path
NewTerm_INSTALL_PATH = /Applications

include $(THEOS_MAKE_PATH)/xcodeproj.mk

before-package::
	@echo "Fixing control architecture..."
	perl -i -pe 's/iphoneos-arm64/appletvos-arm64/g' \
	$(THEOS_STAGING_DIR)/DEBIAN/control

after-stage::
	@echo "Codesigning LoginHelper..."
	@$(TARGET_CODESIGN) $(NewTerm_CODESIGN_FLAGS) \
	$(THEOS_STAGING_DIR)/Applications/NewTerm.app/NewTermLoginHelper
