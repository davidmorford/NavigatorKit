
#import <NavigatorKit/NKNavigatorPattern.h>
#import <objc/runtime.h>

NSString* const NKUniversalURLPattern = @"*";

#pragma mark -

@interface NKNavigatorPattern () {
@protected
	Class targetClass;
	id targetObject;
	NKNavigatorMode navigationMode;
	NSString *parentURL;
	NSInteger transition;
	NSInteger argumentCount;
	UIModalPresentationStyle modalPresentationStyle;
}
	-(BOOL) instantiatesClass;
	-(BOOL) callsInstanceMethod;
	-(void) deduceSelector;
	-(void) analyzeArgument:(id <NKURLPatternText>)pattern method:(Method)method argNames:(NSArray *)argNames;
	-(void) analyzeMethod;
	-(void) analyzeProperties;
	-(BOOL) setArgument:(NSString *)text pattern:(id <NKURLPatternText>)patternText forInvocation:(NSInvocation *)invocation;
	-(void) setArgumentsFromURL:(NSURL *)aURL forInvocation:(NSInvocation *)invocation query:(NSDictionary *)query;
	-(NSComparisonResult) compareSpecificity:(NKURLNavigatorPattern *)pattern2;
@end

#pragma mark -

@interface NKURLNavigatorPattern () {
@protected
	NSString *URL;
	NSString *scheme;
	NSMutableArray *path;
	NSMutableDictionary *query;
	id <NKURLPatternText> fragment;
	NSInteger specificity;
	SEL selector;
}
-(id <NKURLPatternText>) parseText:(NSString *)aTextString;
-(void) parsePathComponent:(NSString *)aValue;
-(void) parseParameter:(NSString *)aName value:(NSString *)aValue;
@end

#pragma mark -

@implementation NKURLNavigatorPattern

	@synthesize URL; 
	@synthesize scheme;
	@synthesize specificity;
	@synthesize selector;

	#pragma mark -

	-(id) init {
		if (self = [super init]) {
			URL				= nil;
			scheme			= nil;
			path			= [[NSMutableArray alloc] init];
			query			= nil;
			fragment		= nil;
			specificity		= 0;
			selector		= nil;
		}
		return self;
	}


	#pragma mark API

	-(Class) classForInvocation {
		return nil;
	}

	-(void) setSelectorIfPossible:(SEL)aSelector {
		Class cls = [self classForInvocation];
		if (!cls || class_respondsToSelector(cls, aSelector) || class_getClassMethod(cls, aSelector)) {
			selector = aSelector;
		}
	}

	-(void) compileURL {
		NSURL *targetURL	= [NSURL URLWithString:URL];
		scheme				= [targetURL.scheme copy];
		if (targetURL.host) {
			[self parsePathComponent:targetURL.host];
			if (targetURL.path) {
				for (NSString *name in targetURL.path.pathComponents) {
					if (![name isEqualToString:@"/"]) {
						[self parsePathComponent:name];
					}
				}
			}
		}
		
		if (targetURL.query) {
			NSDictionary *queryMap = [targetURL.query queryDictionaryUsingEncoding:NSUTF8StringEncoding];
			for (NSString *name in [queryMap keyEnumerator]) {
				NSString *value = [queryMap objectForKey:name];
				[self parseParameter:name value:value];
			}
		}
		
		if (targetURL.fragment) {
			fragment = [[self parseText:targetURL.fragment] retain];
		}
	}


	#pragma mark SPI

	-(id <NKURLPatternText>) parseText:(NSString *)aTextString {
		NSInteger len = aTextString.length;
		if ((len >= 2) && ([aTextString characterAtIndex:0] == '(') && ([aTextString characterAtIndex:len - 1] == ')')) {
			NSInteger endRange			= len > 3 && [aTextString characterAtIndex:len - 2] == ':' ? len - 3 : len - 2;
			NSString *name				= len > 2 ? [aTextString substringWithRange:NSMakeRange(1, endRange)] : nil;
			NKURLWildcard *wildcard	= [[[NKURLWildcard alloc] init] autorelease];
			wildcard.name				= name;
			++specificity;
			return wildcard;
		}
		else {
			NKURLLiteral *literal	= [[[NKURLLiteral alloc] init] autorelease];
			literal.name	= aTextString;
			specificity		+= 2;
			return literal;
		}
	}

	-(void) parsePathComponent:(NSString *)aValue {
		id <NKURLPatternText> component = [self parseText:aValue];
		[path addObject:component];
	}

	-(void) parseParameter:(NSString *)aName value:(NSString *)aValue {
		if (!query) {
			query = [[NSMutableDictionary alloc] init];
		}
		
		id <NKURLPatternText> component = [self parseText:aValue];
		[query setObject:component forKey:aName];
	}

	-(void) setSelectorWithNames:(NSArray *)aNameList {
		NSString *selectorName	= [[aNameList componentsJoinedByString:@":"] stringByAppendingString:@":"];
		SEL namedSelector		= NSSelectorFromString(selectorName);
		[self setSelectorIfPossible:namedSelector];
	}


	#pragma mark -

	-(void) dealloc {
		[URL release]; URL = nil;
		[scheme release]; scheme = nil;
		[path release]; path = nil;
		[query release]; query = nil;
		[fragment release]; fragment = nil;
		[super dealloc];
	}

@end

#pragma mark -

NKNavigatorArgumentType
NKConvertArgumentType(char argType) {
	if ((argType == 'c') || (argType == 'i') || (argType == 's') || (argType == 'l') || (argType == 'C') || (argType == 'I') || (argType == 'S') || (argType == 'L') ) {
		return NKNavigatorArgumentTypeInteger;
	}
	else if (argType == 'q' || argType == 'Q') {
		return NKNavigatorArgumentTypeLongLong;
	}
	else if (argType == 'f') {
		return NKNavigatorArgumentTypeFloat;
	}
	else if (argType == 'd') {
		return NKNavigatorArgumentTypeDouble;
	}
	else if (argType == 'B') {
		return NKNavigatorArgumentTypeBool;
	}
	else {
		return NKNavigatorArgumentTypePointer;
	}
}

NKNavigatorArgumentType
NKNavigatorArgumentTypeForProperty(Class cls, NSString *propertyName) {
	objc_property_t prop = class_getProperty(cls, propertyName.UTF8String);
	if (prop) {
		const char *type = property_getAttributes(prop);
		return NKConvertArgumentType(type[1]);
	}
	else {
		return NKNavigatorArgumentTypeNone;
	}
}

#pragma mark -

@interface NKURLSelector () {
	NSString *name;
	SEL selector;
	NKURLSelector *next;
}

@end

@implementation NKURLSelector

	@synthesize name;
	@synthesize next;

	#pragma mark -

	-(id) initWithName:(NSString *)aName {
		if (self = [super init]) {
			name		= [aName copy];
			selector	= NSSelectorFromString(name);
			next		= nil;
		}
		return self;
	}
	
	#pragma mark -

	-(NSString *) perform:(id)anObject returnType:(NKNavigatorArgumentType)aReturnType {
		if (next) {
			id value = [anObject performSelector:selector];
			return [next perform:value returnType:aReturnType];
		}
		else {
			NSMethodSignature *sig		= [anObject methodSignatureForSelector:selector];
			NSInvocation *invocation	= [NSInvocation invocationWithMethodSignature:sig];
			[invocation setTarget:anObject];
			[invocation setSelector:selector];
			[invocation invoke];
			
			if (!aReturnType) {
				aReturnType = NKNavigatorArgumentTypeForProperty([anObject class], name);
			}
			
			switch (aReturnType) {
				case NKNavigatorArgumentTypeNone: {
					return @"";
				}
				case NKNavigatorArgumentTypeInteger: {
					int val = 0;
					[invocation getReturnValue:&val];
					return [NSString stringWithFormat:@"%d", val];
				}
				case NKNavigatorArgumentTypeLongLong: {
					long long val = 0;
					[invocation getReturnValue:&val];
					return [NSString stringWithFormat:@"%lld", val];
				}
				case NKNavigatorArgumentTypeFloat: {
					float val = 0.0;
					[invocation getReturnValue:&val];
					return [NSString stringWithFormat:@"%f", val];
				}
				case NKNavigatorArgumentTypeDouble: {
					double val = 0.0;
					[invocation getReturnValue:&val];
					return [NSString stringWithFormat:@"%f", val];
				}
				case NKNavigatorArgumentTypeBool: {
					BOOL val = FALSE;
					[invocation getReturnValue:&val];
					return [NSString stringWithFormat:@"%d", val];
				}
				default: {
					id val = nil;
					[invocation getReturnValue:&val];
					return [NSString stringWithFormat:@"%@", val];
				}
			}
			return @"";
		}
	}


	#pragma mark -

	-(void) dealloc {
		[name release]; name = nil;
		[next release]; next = nil;
		[super dealloc];
	}

@end

#pragma mark -

@interface NKURLLiteral () {
	NSString *name;
}

@end

@implementation NKURLLiteral

	@synthesize name;

	#pragma mark -

	-(id) init {
		if (self = [super init]) {
			name = nil;
		}
		return self;
	}


	#pragma mark API

	-(BOOL) match:(NSString *)aTextString {
		return [aTextString isEqualToString:name];
	}

	-(NSString *) convertPropertyOfObject:(id)anObject {
		return name;
	}


	#pragma mark -

	-(void) dealloc {
		[name release]; name = nil;
		[super dealloc];
	}

@end

#pragma mark -

@interface NKURLWildcard () {
	NSString *name;
	NSInteger argIndex;
	NKNavigatorArgumentType argType;
	NKURLSelector *selector;
}

@end

@implementation NKURLWildcard

	@synthesize name;
	@synthesize argIndex; 
	@synthesize argType; 
	@synthesize selector;

	#pragma mark -

	-(id) init {
		if (self = [super init]) {
			name		= nil;
			argIndex	= NSNotFound;
			argType		= NKNavigatorArgumentTypeNone;
			selector	= nil;
		}
		return self;
	}


	#pragma mark API

	-(BOOL) match:(NSString *)aTextString {
		return TRUE;
	}

	-(NSString *) convertPropertyOfObject:(id)anObject {
		if (selector) {
			return [selector perform:anObject returnType:argType];
		}
		else {
			return @"";
		}
	}

	-(void) deduceSelectorForClass:(Class)aClass {
		NSArray *names = [name componentsSeparatedByString:@"."];
		if (names.count > 1) {
			NKURLSelector *URLSelector = nil;
			for (NSString *selectorName in names) {
				NKURLSelector *newSelector = [[[NKURLSelector alloc] initWithName:selectorName] autorelease];
				if (URLSelector) {
					URLSelector.next = newSelector;
				}
				else {
					self.selector = newSelector;
				}
				URLSelector = newSelector;
			}
		}
		else {
			self.argType	= NKNavigatorArgumentTypeForProperty(aClass, name);
			self.selector	= [[[NKURLSelector alloc] initWithName:name] autorelease];
		}
	}


	#pragma mark -

	-(void) dealloc {
		[name release]; name = nil;
		[selector release]; selector = nil;
		[super dealloc];
	}

@end

#pragma mark -

@interface NKURLGeneratorPattern () {
	Class targetClass;
}
@end

@implementation NKURLGeneratorPattern

@synthesize targetClass;

#pragma mark -

-(id) init {
	return [self initWithTargetClass:nil];
}

-(id) initWithTargetClass:(id)aTargetClass {
	if (self = [super init]) {
		targetClass = aTargetClass;
	}
	return self;
}


#pragma mark NKURLNavigationPattern

-(Class) classForInvocation {
	return targetClass;
}


#pragma mark API

-(void) compile {
	[self compileURL];
	for (id <NKURLPatternText> pattern in path) {
		if ([pattern isKindOfClass:[NKURLWildcard class]]) {
			NKURLWildcard *wildcard = (NKURLWildcard *)pattern;
			[wildcard deduceSelectorForClass:targetClass];
		}
	}
	
	for (id <NKURLPatternText> pattern in [query objectEnumerator]) {
		if ([pattern isKindOfClass:[NKURLWildcard class]]) {
			NKURLWildcard *wildcard = (NKURLWildcard *)pattern;
			[wildcard deduceSelectorForClass:targetClass];
		}
	}
}

-(NSString *) generateURLFromObject:(id)object {
	NSMutableArray *paths	= [NSMutableArray array];
	NSMutableArray *queries = nil;
	[paths addObject:[NSString stringWithFormat:@"%@:/", scheme]];
	
	for (id <NKURLPatternText> patternText in path) {
		NSString *value = [patternText convertPropertyOfObject:object];
		[paths addObject:value];
	}
	
	for (NSString *name in [query keyEnumerator]) {
		id <NKURLPatternText> patternText	= [query objectForKey:name];
		NSString *value						= [patternText convertPropertyOfObject:object];
		NSString *pair						= [NSString stringWithFormat:@"%@=%@", name, value];
		if (!queries) {
			queries = [NSMutableArray array];
		}
		[queries addObject:pair];
	}
	
	NSString *generatedPath = [paths componentsJoinedByString:@"/"];
	if (queries) {
		NSString *queryString = [queries componentsJoinedByString:@"&"];
		return [generatedPath stringByAppendingFormat:@"?%@", queryString];
	}
	else {
		return generatedPath;
	}
}


#pragma mark -

-(void) dealloc {
	[super dealloc];
}

@end

#pragma mark -

@implementation NKNavigatorPattern

@synthesize targetClass;
@synthesize targetObject;
@synthesize navigationMode;
@synthesize parentURL;
@synthesize transition;
@synthesize modalPresentationStyle;
@synthesize argumentCount;

#pragma mark -

-(id) init {
	return [self initWithTarget:nil];
}

-(id) initWithTarget:(id)aTarget {
	return [self initWithTarget:aTarget mode:NKNavigatorModeNone];
}

-(id) initWithTarget:(id)aTarget mode:(NKNavigatorMode)aNavigationMode {
	if (self = [super init]) {
		targetClass		= nil;
		targetObject	= nil;
		navigationMode	= aNavigationMode;
		parentURL		= nil;
		transition		= 0;
		argumentCount	= 0;
		
		if (([aTarget class] == aTarget) && aNavigationMode) {
			targetClass = aTarget;
		}
		else {
			targetObject = aTarget;
		}
	}
	return self;
}


#pragma mark NKURLNavigationPattern

-(Class) classForInvocation {
	return targetClass ? targetClass : [targetObject class];
}


#pragma mark API

-(BOOL) isUniversal {
	return [URL isEqualToString:NKUniversalURLPattern];
}

-(BOOL) isFragment {
	return [URL rangeOfString:@"#" options:NSBackwardsSearch].location != NSNotFound;
}

-(void) compile {
	if ([URL isEqualToString:NKUniversalURLPattern]) {
		if (!selector) {
			[self deduceSelector];
		}
	}
	else {
		[self compileURL];
		
		// Don't do this if the pattern is a URL generator
		if (!selector) {
			[self deduceSelector];
		}
		if (selector) {
			[self analyzeMethod];
		}
	}
}

-(BOOL) matchURL:(NSURL *)aURL {
	if (!aURL.scheme || !aURL.host || ![scheme isEqualToString:aURL.scheme]) {
		return FALSE;
	}

	NSArray *pathComponents		= aURL.path.pathComponents;
	NSInteger componentCount	= aURL.path.length ? pathComponents.count : (aURL.host ? 1 : 0);
	if (componentCount != path.count) {
		return FALSE;
	}
	
	if (path.count && aURL.host) {
		id <NKURLPatternText>hostPattern = [path objectAtIndex:0];
		if (![hostPattern match:aURL.host]) {
			return FALSE;
		}
	}
	
	for (NSInteger i = 1; i < path.count; ++i) {
		id <NKURLPatternText> pathPattern	= [path objectAtIndex:i];
		NSString *pathText					= [pathComponents objectAtIndex:i];
		if (![pathPattern match:pathText]) {
			return FALSE;
		}
	}
	
	if ((aURL.fragment && !fragment) || (fragment && !aURL.fragment)) {
		return FALSE;
	}
	else if (aURL.fragment && fragment && ![fragment match:aURL.fragment]) {
		return FALSE;
	}
	return TRUE;
}

-(id) invoke:(id)aTarget withURL:(NSURL *)aURL query:(NSDictionary *)aQuery {
	id returnValue			= nil;
	NSMethodSignature *sig	= [aTarget methodSignatureForSelector:self.selector];
	if (sig) {
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
		[invocation setTarget:aTarget];
		[invocation setSelector:self.selector];
		if (self.isUniversal) {
			[invocation setArgument:&aURL atIndex:2];
			if (aQuery) {
				[invocation setArgument:&aQuery atIndex:3];
			}
		}
		else {
			[self setArgumentsFromURL:aURL forInvocation:invocation query:aQuery];
		}
		[invocation invoke];
		
		if (sig.methodReturnLength) {
			[invocation getReturnValue:&returnValue];
		}
	}
	return returnValue;
}

-(id) createObjectFromURL:(NSURL *)aURL query:(NSDictionary *)aQuery {
	id target = nil;
	if (self.instantiatesClass) {
		target = [targetClass alloc];
	}
	else {
		target = [targetObject retain];
	}
	
	id returnValue = nil;
	if (selector) {
		returnValue = [self invoke:target withURL:aURL query:aQuery];
	}
	else if (self.instantiatesClass) {
		returnValue = [target init];
	}
	[target autorelease];
	return returnValue;
}


#pragma mark SPI

-(BOOL) instantiatesClass {
	return targetClass && navigationMode;
}

-(BOOL) callsInstanceMethod {
	return (targetObject && [targetObject class] != targetObject) || targetClass;
}

-(NSComparisonResult) compareSpecificity:(NKURLNavigatorPattern *)aPattern {
	if (specificity > aPattern.specificity) {
		return NSOrderedAscending;
	}
	else if (specificity < aPattern.specificity) {
		return NSOrderedDescending;
	}
	else {
		return NSOrderedSame;
	}
}

-(void) deduceSelector {
	NSMutableArray *parts = [NSMutableArray array];
	for (id <NKURLPatternText> pattern in path) {
		if ([pattern isKindOfClass:[NKURLWildcard class]]) {
			NKURLWildcard *wildcard = (NKURLWildcard *)pattern;
			if (wildcard.name) {
				[parts addObject:wildcard.name];
			}
		}
	}
	
	for (id <NKURLPatternText> pattern in [query objectEnumerator]) {
		if ([pattern isKindOfClass:[NKURLWildcard class]]) {
			NKURLWildcard *wildcard = (NKURLWildcard *)pattern;
			if (wildcard.name) {
				[parts addObject:wildcard.name];
			}
		}
	}
	
	if ([fragment isKindOfClass:[NKURLWildcard class]]) {
		NKURLWildcard *wildcard = (NKURLWildcard *)fragment;
		if (wildcard.name) {
			[parts addObject:wildcard.name];
		}
	}
	
	if (parts.count) {
		[self setSelectorWithNames:parts];
		if (!selector) {
			[parts addObject:@"query"];
			[self setSelectorWithNames:parts];
		}
	}
	else {
		[self setSelectorIfPossible:@selector(initWithNavigatorURL:query:)];
	}
}

-(void) analyzeArgument:(id <NKURLPatternText>)aPattern method:(Method)aMethod argNames:(NSArray *)argNames {
	if ([aPattern isKindOfClass:[NKURLWildcard class]]) {
		NKURLWildcard *wildcard	= (NKURLWildcard *)aPattern;
		wildcard.argIndex			= [argNames indexOfObject:wildcard.name];
		if (wildcard.argIndex == NSNotFound) {
			//NSLog(@"Argument %@ not found in @selector(%s)", wildcard.name, sel_getName(selector));
		}
		else {
			char argType[256];
			method_getArgumentType(aMethod, wildcard.argIndex + 2, argType, 256);
			wildcard.argType = NKConvertArgumentType(argType[0]);
		}
	}
}

-(void) analyzeMethod {
	Class cls		= [self classForInvocation];
	Method method	= [self instantiatesClass] ? class_getInstanceMethod(cls, selector) : class_getClassMethod(cls, selector);
	if (method) {
		argumentCount = method_getNumberOfArguments(method) - 2;
		
		// Look up the index and type of each argument in the method
		const char *selName		= sel_getName(selector);
		NSString *selectorName	= [[NSString alloc] initWithBytesNoCopy:(char *)selName
																 length:strlen(selName)
															   encoding:NSASCIIStringEncoding 
														   freeWhenDone:FALSE];
		
		NSArray *argNames = [selectorName componentsSeparatedByString:@":"];
		for (id <NKURLPatternText> pattern in path) {
			[self analyzeArgument:pattern method:method argNames:argNames];
		}
		
		for (id <NKURLPatternText> pattern in [query objectEnumerator]) {
			[self analyzeArgument:pattern method:method argNames:argNames];
		}
		
		if (fragment) {
			[self analyzeArgument:fragment method:method argNames:argNames];
		}
		[selectorName release];
	}
}

-(void) analyzeProperties {
	Class cls = [self classForInvocation];
	
	for (id <NKURLPatternText> pattern in path) {
		if ([pattern isKindOfClass:[NKURLWildcard class]]) {
			NKURLWildcard *wildcard = (NKURLWildcard *)pattern;
			[wildcard deduceSelectorForClass:cls];
		}
	}
	
	for (id <NKURLPatternText> pattern in [query objectEnumerator]) {
		if ([pattern isKindOfClass:[NKURLWildcard class]]) {
			NKURLWildcard *wildcard = (NKURLWildcard *)pattern;
			[wildcard deduceSelectorForClass:cls];
		}
	}
}

-(BOOL) setArgument:(NSString *)aTextString pattern:(id <NKURLPatternText>)aTextPattern forInvocation:(NSInvocation *)anInvocation {
	if ([aTextPattern isKindOfClass:[NKURLWildcard class]]) {
		NKURLWildcard *wildcard	= (NKURLWildcard *)aTextPattern;
		NSInteger index				= wildcard.argIndex;
		
		if ((index != NSNotFound) && (index < argumentCount) ) {
			switch (wildcard.argType) {
				case NKNavigatorArgumentTypeNone: {
					break;
				}
				case NKNavigatorArgumentTypeInteger: {
					int val = [aTextString intValue];
					[anInvocation setArgument:&val atIndex:index + 2];
					break;
				}
				case NKNavigatorArgumentTypeLongLong: {
					long long val = [aTextString longLongValue];
					[anInvocation setArgument:&val atIndex:index + 2];
					break;
				}
				case NKNavigatorArgumentTypeFloat: {
					float val = [aTextString floatValue];
					[anInvocation setArgument:&val atIndex:index + 2];
					break;
				}
				case NKNavigatorArgumentTypeDouble: {
					double val = [aTextString doubleValue];
					[anInvocation setArgument:&val atIndex:index + 2];
					break;
				}
				case NKNavigatorArgumentTypeBool: {
					BOOL val = [aTextString boolValue];
					[anInvocation setArgument:&val atIndex:index + 2];
					break;
				}
				default: {
					[anInvocation setArgument:&aTextString atIndex:index + 2];
					break;
				}
			}
			return YES;
		}
	}
	return NO;
}

-(void) setArgumentsFromURL:(NSURL *)aURL forInvocation:(NSInvocation *)anInvocation query:(NSDictionary *)aQuery {
	NSInteger remainingArgs				= argumentCount;
	NSMutableDictionary *unmatchedArgs	= aQuery ? [[aQuery mutableCopy] autorelease] : nil;
	NSArray *pathComponents				= aURL.path.pathComponents;
	
	for (NSInteger currentIndex = 0; currentIndex < path.count; ++currentIndex) {
		id <NKURLPatternText> patternText = [path objectAtIndex:currentIndex];
		NSString *text = currentIndex == 0 ? aURL.host : [pathComponents objectAtIndex:currentIndex];
		if ([self setArgument:text pattern:patternText forInvocation:anInvocation]) {
			--remainingArgs;
		}
	}
	
	NSDictionary *URLQuery = [aURL.query queryDictionaryUsingEncoding:NSUTF8StringEncoding];
	if (URLQuery.count) {
		for (NSString *name in [URLQuery keyEnumerator]) {
			id <NKURLPatternText> patternText	= [query objectForKey:name];
			NSString *text						= [URLQuery objectForKey:name];
			if (patternText) {
				if ([self setArgument:text pattern:patternText forInvocation:anInvocation]) {
					--remainingArgs;
				}
			}
			else {
				if (!unmatchedArgs) {
					unmatchedArgs = [NSMutableDictionary dictionary];
				}
				[unmatchedArgs setObject:text forKey:name];
			}
		}
	}
	
	if (remainingArgs && unmatchedArgs.count) {
		// If there are unmatched arguments, and the method signature has extra arguments,
		// then pass the dictionary of unmatched arguments as the last argument
		[anInvocation setArgument:&unmatchedArgs atIndex:argumentCount + 1];
	}
	
	if (aURL.fragment && fragment) {
		[self setArgument:aURL.fragment pattern:fragment forInvocation:anInvocation];
	}
}


#pragma mark -

-(void) dealloc {
	[parentURL release]; parentURL = nil;
	[super dealloc];
}

@end

#pragma mark -

@implementation NSString (NKString)

-(NSDictionary *) queryDictionaryUsingEncoding:(NSStringEncoding)encoding {
	NSCharacterSet *delimiterSet	= [NSCharacterSet characterSetWithCharactersInString:@"&;"];
	NSMutableDictionary *pairs		= [NSMutableDictionary dictionary];
	NSScanner *scanner				= [[[NSScanner alloc] initWithString:self] autorelease];
	
	while (![scanner isAtEnd]) {
		NSString *pairString = nil;
		[scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
		[scanner scanCharactersFromSet:delimiterSet intoString:NULL];
		NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
		
		if (kvPair.count == 2) {
			NSString *key	= [[kvPair objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:encoding];
			NSString *value = [[kvPair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:encoding];
			[pairs setObject:value forKey:key];
		}
	}
	return [NSDictionary dictionaryWithDictionary:pairs];
}

@end
