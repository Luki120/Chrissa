TARGET := iphone:clang:latest:14.0

FRAMEWORK_NAME = Chrissa

rwildcard = $(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

Chrissa_FILES = $(call rwildcard, Sources, *.m *.swift)
Chrissa_CFLAGS = -fobjc-arc
Chrissa_INSTALL_PATH = /Library/Frameworks
Chrissa_PUBLIC_HEADERS = Sources/Headers/Chrissa.h Sources/Headers/CLLocationManager+Private.h
Chrissa_SWIFT_BRIDGING_HEADER = Sources/Headers/Chrissa-Bridging-Header.h

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/framework.mk

before-stage::
	@$(PRINT_FORMAT_YELLOW) "Copying neccessary files for functionality"

	$(eval SOURCE_FILE := $(THEOS_OBJ_DIR)/arm64/generated/$(FRAMEWORK_NAME)-Swift.h)
	$(eval FRAMEWORK_DIR := $(THEOS_OBJ_DIR)/$(FRAMEWORK_NAME).framework)
	@mkdir -p $(FRAMEWORK_DIR)/Modules/$(FRAMEWORK_NAME).swiftmodule/

	@cp $(SOURCE_FILE) $(FRAMEWORK_DIR)/Headers/$(FRAMEWORK_NAME)-Swift.h
	@cp _module.modulemap $(FRAMEWORK_DIR)/Modules/module.modulemap

	@for arch in $(ARCHS); do \
		for file in abi.json swiftmodule swiftsourceinfo; do \
			cp $(THEOS_OBJ_DIR)/$$arch/$(FRAMEWORK_NAME).$$file $(FRAMEWORK_DIR)/Modules/$(FRAMEWORK_NAME).swiftmodule/$$arch-apple-ios.$$file; \
		done; \
	done

after-install::
	install.exec "killall SpringBoard"
