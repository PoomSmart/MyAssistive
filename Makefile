GO_EASY_ON_ME = 1

include theos/makefiles/common.mk

export SDKVERSION = 5.0
export ARCHS = armv7 armv7s

TWEAK_NAME = MyAssistive
MyAssistive_FILES = MyAssistive.xm
MyAssistive_LIBRARIES = flipswitch
MyAssistive_FRAMEWORKS = UIKit QuartzCore
MyAssistive_PRIVATE_FRAMEWORKS = GraphicsServices

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = MyAssistivePref
MyAssistivePref_FILES = MyAssistivePreferenceController.m
MyAssistivePref_INSTALL_PATH = /Library/PreferenceBundles
MyAssistivePref_PRIVATE_FRAMEWORKS = Preferences
MyAssistivePref_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/MyAssistive.plist$(ECHO_END)
	$(ECHO_NOTHING)find $(THEOS_STAGING_DIR) -name .DS_Store | xargs rm -rf$(ECHO_END)
