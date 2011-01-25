
#import <NavigatorKit/NKNavigatorMap.h>
#import <NavigatorKit/NKNavigatorPattern.h>
#import <NavigatorKit/NKViewController.h>
#import <NavigatorKit/NKViewControllerProxy.h>

#import <objc/runtime.h>

static const void *
NKNavigatorObjectMappingsRetain(CFAllocatorRef allocator, const void *value) {
	return value;
}

static void
NKNavigatorObjectMappingsRelease(CFAllocatorRef allocator, const void *value) {
}

#pragma mark -

@interface NKNavigatorMap ()

@property (nonatomic, retain, readwrite) NSMutableDictionary *mutableObjectMappings;
@property (nonatomic, retain, readwrite) NSMutableArray *mutableObjectPatterns;
@property (nonatomic, retain, readwrite) NSMutableArray *mutableFragmentPatterns;
@property (nonatomic, retain, readwrite) NSMutableDictionary *mutableStringPatterns;
@property (nonatomic, retain, readwrite) NSMutableDictionary *schemes;
@property (nonatomic, retain, readwrite) NKNavigatorPattern *defaultObjectPattern;
@property (nonatomic, retain, readwrite) NKNavigatorPattern *hashPattern;
@property (nonatomic, assign, readwrite) BOOL invalidPatterns;

@end

#pragma mark -

@implementation NKNavigatorMap

@synthesize mutableObjectMappings;
@synthesize mutableObjectPatterns;
@synthesize mutableFragmentPatterns;
@synthesize mutableStringPatterns;
@synthesize schemes;
@synthesize defaultObjectPattern;
@synthesize hashPattern;
@synthesize invalidPatterns;

#pragma mark Initializer

-(id) init {
	self = [super init];
	if (!self) {
		return nil;
	}
	CFDictionaryKeyCallBacks keyCallbacks = kCFTypeDictionaryKeyCallBacks;
	CFDictionaryValueCallBacks callbacks = kCFTypeDictionaryValueCallBacks;
	callbacks.retain = NKNavigatorObjectMappingsRetain;
	callbacks.release = NKNavigatorObjectMappingsRelease;
	self.mutableObjectMappings = (NSMutableDictionary *)CFDictionaryCreateMutable(nil, 0, &keyCallbacks, &callbacks);
	
	self.mutableObjectPatterns = [[NSMutableArray alloc] init];
	self.mutableFragmentPatterns = [[NSMutableArray alloc] init];
	self.mutableStringPatterns = [[NSMutableDictionary alloc] init];
	
	self.schemes = [[NSMutableDictionary alloc] init];
	self.defaultObjectPattern = nil;
	self.invalidPatterns = NO;
	return self;
}

#pragma mark SPI

-(NSString *) keyForClass:(Class)aClass withName:(NSString *)aName {
	//const char *className = class_getName(aClass);
	//return [NSString stringWithFormat:@"%s_%@", className, aName ? aName : @""];
	NSString *className = NSStringFromClass(aClass);
	return [NSString stringWithFormat:@"%@_%@", className, aName ? aName : @""];
}

-(void) registerScheme:(NSString *)aScheme {
	if (aScheme) {
		[self.schemes setObject:[NSNull null] forKey:aScheme];
	}
}

-(void) addObjectPattern:(NKNavigatorPattern *)aPattern forURL:(NSString *)aURLString {
	aPattern.URL = aURLString;
	[aPattern compile];
	[self registerScheme:aPattern.scheme];
	
	if (aPattern.isUniversal) {
		self.defaultObjectPattern = nil;
		self.defaultObjectPattern = aPattern;
	}
	else if (aPattern.isFragment) {
		[self.mutableFragmentPatterns addObject:aPattern];
	}
	else {
		self.invalidPatterns = FALSE;
		[self.mutableObjectPatterns addObject:aPattern];
	}
}

-(void) addStringPattern:(NKURLGeneratorPattern *)aPattern forURL:(NSString *)aURLString withName:(NSString *)aName {
	aPattern.URL = aURLString;
	[aPattern compile];
	[self registerScheme:aPattern.scheme];
	NSString *key = [self keyForClass:aPattern.targetClass withName:aName];
	[self.mutableStringPatterns setObject:aPattern forKey:key];
}

-(NKNavigatorPattern *) matchObjectPattern:(NSURL *)aURLString {
	if (self.invalidPatterns) {
		[mutableObjectPatterns sortUsingSelector:@selector(compareSpecificity:)];
		self.invalidPatterns = NO;
	}
	
	for (NKNavigatorPattern *pattern in self.objectPatterns) {
		if ([pattern matchURL:aURLString]) {
			return pattern;
		}
	}
	return self.defaultObjectPattern;
}


#pragma mark -

-(NSDictionary *) objectMappings {
	return [NSDictionary dictionaryWithDictionary:self.mutableObjectMappings];
}

-(NSArray *) objectPatterns {
	return [NSArray arrayWithArray:self.mutableObjectPatterns];
}

-(NSArray *) fragmentPatterns {
	return [NSArray arrayWithArray:self.mutableFragmentPatterns];
}

-(NSDictionary *) stringPatterns {
	return [NSDictionary dictionaryWithDictionary:self.mutableStringPatterns];
}


#pragma mark API

-(void) from:(NSString *)aURLString toObject:(id)aTarget {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget];
	[self addObjectPattern:pattern forURL:aURLString];
	[pattern release];
}

-(void) from:(NSString *)aURLString toObject:(id)aTarget selector:(SEL)aSelector {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget];
	pattern.selector = aSelector;
	[self addObjectPattern:pattern forURL:aURLString];
	[pattern release];
}


#pragma mark -

-(void) from:(NSString *)aURL toViewController:(id)aTarget {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget mode:NKNavigatorModeCreate];
	[self addObjectPattern:pattern forURL:aURL];
	[pattern release];
}

-(void) from:(NSString *)aURL toViewController:(id)aTarget parent:(NSString *)aParentURL {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget mode:NKNavigatorModeCreate];
	pattern.parentURL = aParentURL;
	[self addObjectPattern:pattern forURL:aURL];
	[pattern release];
}

-(void) from:(NSString *)aURL toViewController:(id)aTarget parent:(NSString *)aParentURL  selector:(SEL)aSelector transition:(NSInteger)aTransition {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget mode:NKNavigatorModeCreate];
	pattern.parentURL = aParentURL;
	pattern.selector = aSelector;
	pattern.transition = aTransition;
	[self addObjectPattern:pattern forURL:aURL];
	[pattern release];
}

-(void) from:(NSString *)aURL toViewController:(id)aTarget selector:(SEL)aSelector {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget mode:NKNavigatorModeCreate];
	pattern.selector = aSelector;
	[self addObjectPattern:pattern forURL:aURL];
	[pattern release];
}

-(void) from:(NSString *)aURL toViewController:(id)aTarget transition:(NSInteger)aTransition {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget mode:NKNavigatorModeCreate];
	pattern.transition = aTransition;
	[self addObjectPattern:pattern forURL:aURL];
	[pattern release];
}


#pragma mark -

-(void) from:(NSString *)aURL toSharedViewController:(id)aTarget {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget mode:NKNavigatorModeShare];
	[self addObjectPattern:pattern forURL:aURL];
	[pattern release];
}

-(void) from:(NSString *)URL toSharedViewController:(id)target selector:(SEL)selector {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:target mode:NKNavigatorModeShare];
	pattern.selector = selector;
	[self addObjectPattern:pattern forURL:URL];
	[pattern release];
}

-(void) from:(NSString *)aURL toSharedViewController:(id)aTarget parent:(NSString *)aParentURL {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget mode:NKNavigatorModeShare];
	pattern.parentURL = aParentURL;
	[self addObjectPattern:pattern forURL:aURL];
	[pattern release];
}

-(void) from:(NSString *)aURL toSharedViewController:(id)aTarget parent:(NSString *)aParentURL selector:(SEL)aSelector {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget mode:NKNavigatorModeShare];
	pattern.parentURL = aParentURL;
	pattern.selector = aSelector;
	[self addObjectPattern:pattern forURL:aURL];
	[pattern release];
}


#pragma mark -

-(void) from:(NSString *)aURL toModalViewController:(id)aTarget {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget mode:NKNavigatorModeModal];
	[self addObjectPattern:pattern forURL:aURL];
	[pattern release];
}

-(void) from:(NSString *)aURL toModalViewController:(id)aTarget parent:(NSString *)aParentURL selector:(SEL)aSelector transition:(NSInteger)aTransition {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget mode:NKNavigatorModeModal];
	pattern.parentURL = aParentURL;
	pattern.selector = aSelector;
	pattern.transition = aTransition;
	[self addObjectPattern:pattern forURL:aURL];
	[pattern release];
}

-(void) from:(NSString *)aURL toModalViewController:(id)aTarget selector:(SEL)aSelector {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget mode:NKNavigatorModeModal];
	pattern.selector = aSelector;
	[self addObjectPattern:pattern forURL:aURL];
	[pattern release];
}

-(void) from:(NSString *)aURL toModalViewController:(id)aTarget transition:(NSInteger)aTransition {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget mode:NKNavigatorModeModal];
	pattern.transition = aTransition;
	[self addObjectPattern:pattern forURL:aURL];
	[pattern release];
}

-(void) from:(NSString *)aURL toModalViewController:(id)aTarget presentationStyle:(UIModalPresentationStyle)aStyle {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget mode:NKNavigatorModeModal];
	pattern.modalPresentationStyle = aStyle;
	[self addObjectPattern:pattern forURL:aURL];
	[pattern release];
}

-(void) from:(NSString *)aURL toModalViewController:(id)aTarget parent:(NSString *)aParentURL presentationStyle:(UIModalPresentationStyle)aStyle {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget mode:NKNavigatorModeModal];
	pattern.parentURL = aParentURL;
	pattern.modalPresentationStyle = aStyle;
	[self addObjectPattern:pattern forURL:aURL];
	[pattern release];
}


#pragma mark -

-(void) from:(NSString *)aURL toEmptyHistoryViewController:(id)aTarget {
	NKNavigatorPattern *pattern = [[NKNavigatorPattern alloc] initWithTarget:aTarget mode:NKNavigatorModeEmptyHistory];
	[self addObjectPattern:pattern forURL:aURL];
	[pattern release];
}


#pragma mark -

-(void) from:(Class)aClass toURL:(NSString *)aURL {
	NKURLGeneratorPattern *pattern = [[NKURLGeneratorPattern alloc] initWithTargetClass:aClass];
	[self addStringPattern:pattern forURL:aURL withName:nil];
	[pattern release];
}

-(void) from:(Class)aClass name:(NSString *)aName toURL:(NSString *)aURL {
	NKURLGeneratorPattern *pattern = [[NKURLGeneratorPattern alloc] initWithTargetClass:aClass];
	[self addStringPattern:pattern forURL:aURL withName:aName];
	[pattern release];
}


#pragma mark -	

-(void) setObject:(id)anObject forURL:(NSString *)aURL {
	// Normalize the URL first
	[self.mutableObjectMappings setObject:anObject forKey:aURL];
}

-(void) removeURL:(NSString *)aURL {
	[self.mutableObjectMappings removeObjectForKey:aURL];
	for (NKNavigatorPattern *currentPattern in self.objectPatterns) {
		if ([aURL isEqualToString:currentPattern.URL]) {
			[mutableObjectPatterns removeObject:currentPattern];
			break;
		}
	}
}

-(void) removeObject:(id)anObject {
	NSMutableArray *URLsToRemove = [NSMutableArray array];
	for (NSString *mappedURL in self.objectMappings) {
		if (anObject == [mutableObjectMappings objectForKey:mappedURL]) {
			[URLsToRemove addObject:mappedURL];
		}
	}
	[self.mutableObjectMappings removeObjectsForKeys:URLsToRemove];
	NSMutableArray *patternsToRemove = [NSMutableArray array];
	for (NKNavigatorPattern *pattern in self.objectPatterns) {
		if (anObject == pattern.targetObject) {
			[patternsToRemove addObject:pattern];
		}
	}
	[self.mutableObjectPatterns removeObjectsInArray:patternsToRemove];
}

-(void) removeObjectForURL:(NSString *)aURL {
	[self.mutableObjectMappings removeObjectForKey:aURL];
}

-(void) removeAllObjects {
	self.mutableObjectMappings = nil;
}

-(id) objectForURL:(NSString *)aURL {
	return [self objectForURL:aURL query:nil pattern:nil];
}

-(id) objectForURL:(NSString *)aURL query:(NSDictionary *)aQuery {
	return [self objectForURL:aURL query:aQuery pattern:nil];
}

-(id) objectForURL:(NSString *)aURL query:(NSDictionary *)aQuery pattern:(NKNavigatorPattern **)aPatternRef {
	id object = nil;
	if (self.mutableObjectMappings) {
		object = [self.mutableObjectMappings objectForKey:aURL];
		if (object && !aPatternRef) {
			return object;
		}
	}
	
	NSURL *objectMappingURL = [NSURL URLWithString:aURL];
	NKNavigatorPattern *pattern  = [self matchObjectPattern:objectMappingURL];
	if (pattern) {
		if (!object) {
			object = [pattern createObjectFromURL:objectMappingURL query:aQuery];
		}
		if ((pattern.navigationMode == NKNavigatorModeShare) && object) {
			// if a shared view controller, put it in the cache and remove dying controllers from our binding cache as needed.
			// Create a proxy around it, so we get notified when it deallocates.
			if ([object isKindOfClass:[UIViewController class]] && ![object isKindOfClass:[NKViewController class]]) {
				NKViewControllerProxy *proxyObject = [[[NKViewControllerProxy alloc] initWithViewController:object] autorelease];
				object = proxyObject;
			}
			[self setObject:object forURL:aURL];
		}
		if (aPatternRef) {
			*aPatternRef = pattern;
		}
		return object;
	}
	else {
		return nil;
	}
}

-(NSString *) URLForObject:(id)anObject {
	return [self URLForObject:anObject withName:nil];
}

-(NSString *) URLForObject:(id)anObject withName:(NSString *)aName {
	Class cls = [anObject class] == anObject ? anObject : [anObject class];
	while (cls) {
		NSString *key = [self keyForClass:cls withName:aName];
		NKURLGeneratorPattern *pattern = [self.mutableStringPatterns objectForKey:key];
		if (pattern) {
			return [pattern generateURLFromObject:anObject];
		}
		else {
			cls = class_getSuperclass(cls);
		}
	}
	return nil;
}


#pragma mark -

-(id) dispatchURL:(NSString *)aURLString toTarget:(id)aTarget query:(NSDictionary *)aQuery {
	NSURL *matchableURL = [NSURL URLWithString:aURLString];
	for (NKNavigatorPattern *pattern in self.fragmentPatterns) {
		if ([pattern matchURL:matchableURL]) {
			return [pattern invoke:aTarget withURL:matchableURL query:aQuery];
		}
	}
	
	// If there is no match, check if the fragment points to a method on the target
	if ([matchableURL fragment]) {
		SEL targetSelector = NSSelectorFromString(matchableURL.fragment);
		if (targetSelector && [aTarget respondsToSelector:targetSelector]) {
			[aTarget performSelector:targetSelector];
		}
	}
	return nil;
}

-(NKNavigatorMode) navigatorModeForURL:(NSString *)aURLString {
	NSURL *matchableURL = [NSURL URLWithString:aURLString];
	if (![self isAppURL:matchableURL]) {
		NKNavigatorPattern *pattern = [self matchObjectPattern:matchableURL];
		if (pattern) {
			return pattern.navigationMode;
		}
	}
	return NKNavigatorModeExternal;
}

-(void) setNavigatorMode:(NKNavigatorMode)aNavigationMode forURL:(NSString *)aURLString {
	NSURL *actualURL = [NSURL URLWithString:aURLString];
	if (![self isAppURL:actualURL]) {
		NKNavigatorPattern *pattern = [self matchObjectPattern:actualURL];
		pattern.navigationMode = aNavigationMode;
	}
}

-(NSInteger) transitionForURL:(NSString *)aURLString {
	NKNavigatorPattern *pattern = [self matchObjectPattern:[NSURL URLWithString:aURLString]];
	return pattern.transition;
}


#pragma mark -

-(BOOL) isSchemeSupported:(NSString *)aScheme {
	return aScheme && !![self.schemes objectForKey:aScheme];
}

-(BOOL) isURLPathSupported:(NSString *)aURLPath {
	NSURL *localURL = [NSURL URLWithString:aURLPath];
	NKNavigatorPattern *pattern  = [self matchObjectPattern:localURL];
	return (nil != pattern);
}

-(BOOL) isAppURL:(NSURL *)aURL {
	return [self isExternalURL:aURL] || ([[UIApplication sharedApplication] canOpenURL:aURL] && ![self isSchemeSupported:aURL.scheme] && ![self isWebURL:aURL]);
}

-(BOOL) isWebURL:(NSURL *)aURL {
	return [aURL.scheme caseInsensitiveCompare:@"http"]	 == NSOrderedSame || 
		   [aURL.scheme caseInsensitiveCompare:@"https"] == NSOrderedSame || 
		   [aURL.scheme caseInsensitiveCompare:@"ftp"]   == NSOrderedSame || 
		   [aURL.scheme caseInsensitiveCompare:@"ftps"]  == NSOrderedSame || 
		   [aURL.scheme caseInsensitiveCompare:@"data"]  == NSOrderedSame;
	
}

-(BOOL) isExternalURL:(NSURL *)aURL {
	if ([aURL.host isEqualToString:@"maps.google.com"]  || 
		[aURL.host isEqualToString:@"itunes.apple.com"] || 
		[aURL.host isEqualToString:@"phobos.apple.com"]) {
		return TRUE;
	}
	else {
		return FALSE;
	}
}


#pragma mark -

-(void) dealloc {
	self.mutableObjectMappings = nil;
	self.mutableObjectPatterns = nil;
	self.mutableFragmentPatterns = nil;
	self.mutableStringPatterns = nil;
	self.schemes = nil;
	self.defaultObjectPattern = nil;
	self.hashPattern = nil;
	[super dealloc];
}

@end
