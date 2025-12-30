# Save the local path
SDL_TTF_LOCAL_PATH := $(call my-dir)

# Enable this if you want to use HarfBuzz
SUPPORT_HARFBUZZ ?= true
HARFBUZZ_LIBRARY_PATH := external/harfbuzz

FREETYPE_LIBRARY_PATH := external/freetype

# Build freetype library
ifneq ($(FREETYPE_LIBRARY_PATH),)
    include $(SDL_TTF_LOCAL_PATH)/$(FREETYPE_LIBRARY_PATH)/Android.mk
endif

# Build the library
ifeq ($(SUPPORT_HARFBUZZ),true)
    include $(SDL_TTF_LOCAL_PATH)/$(HARFBUZZ_LIBRARY_PATH)/Android.mk
endif

# Restore local path
LOCAL_PATH := $(SDL_TTF_LOCAL_PATH)
include $(CLEAR_VARS)

LOCAL_MODULE := SDL2_ttf

LOCAL_ARM_MODE := arm

LOCAL_C_INCLUDES := $(LOCAL_PATH)

LOCAL_SRC_FILES := SDL_ttf.c.neon

ifneq ($(FREETYPE_LIBRARY_PATH),)
    LOCAL_C_INCLUDES += $(LOCAL_PATH)/$(FREETYPE_LIBRARY_PATH)/include
    LOCAL_STATIC_LIBRARIES += freetype
endif

ifeq ($(SUPPORT_HARFBUZZ),true)
    LOCAL_C_INCLUDES += $(LOCAL_PATH)/$(HARFBUZZ_LIBRARY_PATH)/src
    LOCAL_CFLAGS += -DTTF_USE_HARFBUZZ
    LOCAL_STATIC_LIBRARIES += harfbuzz
endif

ifeq ($(APP_OPTIM),debug)
	LOCAL_LDLIBS := $(SDL_TTF_LOCAL_PATH)/../../../../../sdl2/android-project/app/build/intermediates/merged_native_libs/debug/mergeDebugNativeLibs/out/lib/$(TARGET_ARCH_ABI)/libSDL2.so
else
	LOCAL_LDLIBS := $(SDL_TTF_LOCAL_PATH)/../../../../../sdl2/android-project/app/build/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out/lib/$(TARGET_ARCH_ABI)/libSDL2.so
endif

LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../../../../sdl2/include

#LOCAL_SHARED_LIBRARIES := SDL2

LOCAL_EXPORT_C_INCLUDES += $(LOCAL_C_INCLUDES)

include $(BUILD_SHARED_LIBRARY)

###########################
#
# SDL2_ttf static library
#
###########################

LOCAL_MODULE := SDL2_ttf_static

LOCAL_ARM_MODE := arm

LOCAL_MODULE_FILENAME := libSDL2_ttf

LOCAL_LDLIBS :=
LOCAL_EXPORT_LDLIBS :=

include $(BUILD_STATIC_LIBRARY)

