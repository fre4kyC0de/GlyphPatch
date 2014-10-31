include theos/makefiles/common.mk

TWEAK_NAME = GlyphPatch
GlyphPatch_FILES = Tweak.x
GlyphPatch_FRAMEWORKS = CoreText

include $(THEOS_MAKE_PATH)/tweak.mk
