#import <substrate.h>
#import <CoreText/CoreText.h>

#define DECL_FUNC(name, ret, ...) \
    static ret (*original_ ## name)(__VA_ARGS__); \
    ret custom_ ## name(__VA_ARGS__)
#define HOOK_FUNC(image_to_hook, name) do { \
    void *_ ## name = MSFindSymbol(image_to_hook, "_" #name); \
    if (_ ## name == NULL) { \
        return; \
    } \
    MSHookFunction(_ ## name, (void *) custom_ ## name, (void **) &original_ ## name); \
} while(0)

DECL_FUNC(CTRunGetGlyphCount, CFIndex, CTRunRef run)
{
	CFIndex ret = original_CTRunGetGlyphCount(run);
	if ((int)ret < 0)
	{
		return (CFIndex)0;
	}
	return ret;
}

%ctor {
	MSImageRef image = MSGetImageByName("/System/Library/Frameworks/CoreText.framework/CoreText");
    if (image == NULL) {
        //NSLog(@"GlyphPatch: Failed to load CoreText.framework!");
        return;
    }
	NSLog(@"GlyphPatch: Fixing CoreText.framework...");
    HOOK_FUNC(image, CTRunGetGlyphCount);
}
