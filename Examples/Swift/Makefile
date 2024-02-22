TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = Rhus

Rhus_FILES = $(shell find Sources/Rhus -name '*.swift') $(shell find Sources/RhusC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Rhus_CFLAGS = -fobjc-arc -ISourcesRhusC/include
Rhus_SWIFTFLAGS = -ISources/RhusC/include
Rhus_EXTRA_FRAMEWORKS = Chrissa

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
