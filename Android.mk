##
##
## Copyright 2007, The Android Open Source Project
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##

BASE_PATH := $(call my-dir)
include $(CLEAR_VARS)

# if you need to make webcore huge (for debugging), enable this line
#LOCAL_PRELINK_MODULE := false

# Define our module and find the intermediates directory
LOCAL_MODULE := libwebcore
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
base_intermediates := $(call local-intermediates-dir)

# Using := here prevents recursive expansion
WEBKIT_SRC_FILES :=

# We have to use bison 2.3
include $(BASE_PATH)/bison_check.mk

# Include source files for JavaScriptCore
d := JavaScriptCore
LOCAL_PATH := $(BASE_PATH)/$d
intermediates := $(base_intermediates)/$d
include $(LOCAL_PATH)/Android.mk
WEBKIT_SRC_FILES += $(addprefix $d/,$(LOCAL_SRC_FILES))

# Include source files for WebCore
d := WebCore
LOCAL_PATH := $(BASE_PATH)/$d
intermediates := $(base_intermediates)/$d
include $(LOCAL_PATH)/Android.mk
WEBKIT_SRC_FILES += $(addprefix $d/,$(LOCAL_SRC_FILES))

# Include the derived source files for WebCore. Uses the same path as
# WebCore
include $(LOCAL_PATH)/Android.derived.mk
WEBKIT_SRC_FILES += $(addprefix $d/,$(LOCAL_SRC_FILES))

# Include source files for android WebKit port
d := WebKit
LOCAL_PATH := $(BASE_PATH)/$d
intermediates := $(base_intermediates)/$d
include $(LOCAL_PATH)/Android.mk
WEBKIT_SRC_FILES += $(addprefix $d/,$(LOCAL_SRC_FILES))

# Redefine LOCAL_PATH here so the build system is not confused
LOCAL_PATH := $(BASE_PATH)

# Define our compiler flags
LOCAL_CFLAGS += -Wno-endif-labels -Wno-import -Wno-format
LOCAL_CFLAGS += -fno-strict-aliasing
LOCAL_CFLAGS += -include "WebCorePrefixAndroid.h"

ifeq ($(TARGET_ARCH),arm)
LOCAL_CFLAGS += -Darm -fvisibility=hidden
endif

ifeq ($(TARGET_ARCH),mips)
LOCAL_CFLAGS += -fvisibility=hidden
endif

ifeq ($(TARGET_ARCH),ppc)
LOCAL_CFLAGS += -fvisibility=hidden
endif

ifeq ($(WEBCORE_INSTRUMENTATION),true)
LOCAL_CFLAGS += -DANDROID_INSTRUMENT
endif

# LOCAL_LDLIBS is used in simulator builds only and simulator builds are only
# valid on Linux
LOCAL_LDLIBS += -lpthread -ldl

# Build our list of include paths. We include WebKit/android/icu first so that
# any files that include <unicode/ucnv.h> will include our ucnv.h first. We
# also add external/ as an include directory so that we can specify the real
# icu header directory as a more exact reference to avoid including our ucnv.h.
LOCAL_C_INCLUDES := \
	$(JNI_H_INCLUDE) \
	$(LOCAL_PATH)/WebKit/android/icu \
	external/ \
	external/icu4c/common \
	external/icu4c/i18n \
	external/libxml2/include \
	external/skia/emoji \
	external/skia/include/core \
	external/skia/include/effects \
	external/skia/include/images \
	external/skia/include/ports \
	external/skia/include/utils \
	external/skia/src/ports \
	external/sqlite/dist \
	frameworks/base/core/jni/android/graphics \
	$(LOCAL_PATH)/WebCore \
	$(LOCAL_PATH)/WebCore/bindings/js \
	$(LOCAL_PATH)/WebCore/bridge \
	$(LOCAL_PATH)/WebCore/bridge/c \
	$(LOCAL_PATH)/WebCore/bridge/jni \
	$(LOCAL_PATH)/WebCore/css \
	$(LOCAL_PATH)/WebCore/dom \
	$(LOCAL_PATH)/WebCore/editing \
	$(LOCAL_PATH)/WebCore/history \
	$(LOCAL_PATH)/WebCore/html \
	$(LOCAL_PATH)/WebCore/inspector \
	$(LOCAL_PATH)/WebCore/loader \
	$(LOCAL_PATH)/WebCore/loader/appcache \
	$(LOCAL_PATH)/WebCore/loader/icon \
	$(LOCAL_PATH)/WebCore/page \
	$(LOCAL_PATH)/WebCore/page/android \
	$(LOCAL_PATH)/WebCore/page/animation \
	$(LOCAL_PATH)/WebCore/platform \
	$(LOCAL_PATH)/WebCore/platform/android \
	$(LOCAL_PATH)/WebCore/platform/animation \
	$(LOCAL_PATH)/WebCore/platform/graphics \
	$(LOCAL_PATH)/WebCore/platform/graphics/android \
	$(LOCAL_PATH)/WebCore/platform/graphics/network \
	$(LOCAL_PATH)/WebCore/platform/graphics/skia \
	$(LOCAL_PATH)/WebCore/platform/graphics/transforms \
	$(LOCAL_PATH)/WebCore/platform/image-decoders \
	$(LOCAL_PATH)/WebCore/platform/network \
	$(LOCAL_PATH)/WebCore/platform/network/android \
	$(LOCAL_PATH)/WebCore/platform/sql \
	$(LOCAL_PATH)/WebCore/platform/text \
	$(LOCAL_PATH)/WebCore/plugins \
	$(LOCAL_PATH)/WebCore/rendering \
	$(LOCAL_PATH)/WebCore/rendering/style \
	$(LOCAL_PATH)/WebCore/storage \
	$(LOCAL_PATH)/WebCore/xml \
	$(LOCAL_PATH)/WebKit/android \
	$(LOCAL_PATH)/WebKit/android/WebCoreSupport \
	$(LOCAL_PATH)/WebKit/android/jni \
	$(LOCAL_PATH)/WebKit/android/nav \
	$(LOCAL_PATH)/WebKit/android/plugins \
	$(LOCAL_PATH)/WebKit/android/stl \
	$(LOCAL_PATH)/JavaScriptCore \
	$(LOCAL_PATH)/JavaScriptCore/API \
	$(LOCAL_PATH)/JavaScriptCore/assembler \
	$(LOCAL_PATH)/JavaScriptCore/bytecode \
	$(LOCAL_PATH)/JavaScriptCore/bytecompiler \
	$(LOCAL_PATH)/JavaScriptCore/debugger \
	$(LOCAL_PATH)/JavaScriptCore/parser \
	$(LOCAL_PATH)/JavaScriptCore/jit \
	$(LOCAL_PATH)/JavaScriptCore/interpreter \
	$(LOCAL_PATH)/JavaScriptCore/pcre \
	$(LOCAL_PATH)/JavaScriptCore/profiler \
	$(LOCAL_PATH)/JavaScriptCore/runtime \
	$(LOCAL_PATH)/JavaScriptCore/wrec \
	$(LOCAL_PATH)/JavaScriptCore/wtf \
	$(LOCAL_PATH)/JavaScriptCore/wtf/unicode \
	$(LOCAL_PATH)/JavaScriptCore/wtf/unicode/icu \
	$(LOCAL_PATH)/JavaScriptCore/ForwardingHeaders \
	$(base_intermediates)/JavaScriptCore \
	$(base_intermediates)/JavaScriptCore/parser \
	$(base_intermediates)/JavaScriptCore/runtime \
	$(base_intermediates)/WebCore/ \
	$(base_intermediates)/WebCore/bindings/js \
	$(base_intermediates)/WebCore/css \
	$(base_intermediates)/WebCore/dom \
	$(base_intermediates)/WebCore/html \
	$(base_intermediates)/WebCore/inspector \
	$(base_intermediates)/WebCore/loader/appcache \
	$(base_intermediates)/WebCore/page \
	$(base_intermediates)/WebCore/platform \
	$(base_intermediates)/WebCore/plugins \
	$(base_intermediates)/WebCore/xml

# Build the list of shared libraries
LOCAL_SHARED_LIBRARIES := \
	libandroid_runtime \
	libnativehelper \
	libsqlite \
	libsgl \
	libcorecg \
	libutils \
	libui \
	libcutils \
	libicuuc \
	libicudata \
	libicui18n \
	libmedia

# We have to use the android version of libdl when we are not on the simulator
ifneq ($(TARGET_SIMULATOR),true)
LOCAL_SHARED_LIBRARIES += libdl
endif

# Build the list of static libraries
LOCAL_STATIC_LIBRARIES := libxml2

# Redefine LOCAL_SRC_FILES to be all the WebKit source files
LOCAL_SRC_FILES := $(WEBKIT_SRC_FILES)

# Build the library all at once
include $(BUILD_SHARED_LIBRARY)

# Build the plugin test separately from libwebcore
include $(BASE_PATH)/WebKit/android/plugins/sample/Android.mk

# Build the wds client
include $(BASE_PATH)/WebKit/android/wds/client/Android.mk

# Build the performance command line tool.
# XXX: Uncomment this include to build webcore_test. In order for the test to
# link with libwebcore, remove -fvisibility=hidden from LOCAL_CFLAGS above
#include $(BASE_PATH)/perf/Android.mk
