export TARGET = appletvos:clang:latest:15.0
export ARCHS = arm64

export INSTALL_PREFIX =
export DEB_ARCH = appletvos-arm

INSTALL_TARGET_PROCESSES = NewTerm

include $(THEOS)/makefiles/common.mk

XCODEPROJ_NAME = NewTerm

# tvOS scheme
NewTerm_XCODE_SCHEME = NewTerm (tvOS)

# Передаём install prefix в Xcode
NewTerm_XCODEFLAGS = INSTALL_PREFIX=$(INSTALL_PREFIX)

# Entitlements
NewTerm_CODESIGN_FLAGS = -SApp/entitlements.plist

# Rootful путь
NewTerm_INSTALL_PATH = /Applications

include $(THEOS_MAKE_PATH)/xcodeproj.mk

before-package::
	@echo "Fixing architecture in control file..."
	perl -i -pe 's/iphoneos-arm/appletvos-arm/g' \
	$(THEOS_STAGING_DIR)/DEBIAN/control

after-stage::
	@echo "Codesigning LoginHelper..."
	@$(TARGET_CODESIGN) $(NewTerm_CODESIGN_FLAGS) \
	$(THEOS_STAGING_DIR)/Applications/NewTerm.app/NewTermLoginHelper
