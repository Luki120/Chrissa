TARGET := iphone:clang:18.5:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = Rhus

Rhus_FILES = $(wildcard */**/**.m) $(wildcard */**/**/**.swift)
Rhus_CFLAGS = -fobjc-arc -ISources/RhusC/include
Rhus_SWIFTFLAGS = -ISources/RhusC/include
Rhus_EXTRA_FRAMEWORKS = Chrissa
Rhus_PRIVATE_FRAMEWORKS = SpringBoard

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
