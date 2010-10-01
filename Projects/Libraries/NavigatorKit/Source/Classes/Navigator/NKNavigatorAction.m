
#import <NavigatorKit/NKNavigatorAction.h>
#import <NavigatorKit/NKUIDevice.h>

@interface NKNavigatorAction () {
	NSString *URLPath;
	NSString *parentURLPath;
	NSDictionary *query;
	NSDictionary *state;
}

@end

#pragma mark -

@implementation NKNavigatorAction

@synthesize URLPath;
@synthesize parentURLPath;
@synthesize query;
@synthesize sender;
@synthesize animated;
@synthesize withDelay;
@synthesize transition;
@synthesize modalPresentationStyle;

#pragma mark Constructor

+(id) actionWithNavigatorURLPath:(NSString *)aURLPath {
	return [[[[self class] alloc] initWithNavigatorURLPath:aURLPath] autorelease];
}


#pragma mark Initializers

-(id) initWithNavigatorURLPath:(NSString *)aURLPath {
	self = [super init];
	if (self == nil) {
		return nil;
	}
	self.URLPath	= aURLPath;
	self.animated	= TRUE;
	self.withDelay	= FALSE;
	self.transition = UIViewAnimationTransitionNone;
	/*if (NKUIDeviceHasUserIntefaceIdiom() && NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		self.modalPresentationStyle = UIModalPresentationCurrentContext;
	}
	else {*/
		self.modalPresentationStyle = UIModalPresentationFullScreen;
	/*}*/
	return self;
}

-(id) initWithNavigatorURLPath:(NSString *)aURLPath query:(NSDictionary *)aQuery {
	self = [self initWithNavigatorURLPath:aURLPath];
	if (self == nil) {
		return nil;
	}
	self.query = aQuery;
	return self;
}

-(id) initWithNavigatorURLPath:(NSString *)aURLPath parentURLPath:(NSString *)aParentPath {
	self = [self initWithNavigatorURLPath:aURLPath];
	if (self == nil) {
		return nil;
	}
	self.parentURLPath = aParentPath;
	return self;
}

-(id) initWithNavigatorURLPath:(NSString *)aURLPath parentURLPath:(NSString *)aParentPath query:(NSDictionary *)aQuery {
	self = [self initWithNavigatorURLPath:aURLPath parentURLPath:aParentPath];
	if (self == nil) {
		return nil;
	}
	self.query = aQuery;
	return self;
}

-(id) initWithNavigatorURLPath:(NSString *)aURLPath animated:(BOOL)animatedFlag {
	self = [self initWithNavigatorURLPath:aURLPath];
	if (self == nil) {
		return nil;
	}
	self.animated = animatedFlag;
	return self;
}


#pragma mark <NSCopying>

-(id) copyWithZone:(NSZone *)zone {
	NKNavigatorAction *action = [[[self class] allocWithZone:zone] init];
	action.URLPath			= self.URLPath;
	action.parentURLPath	= self.parentURLPath;
	action.query			= [self.query mutableCopyWithZone:zone];
	action.sender			= self.sender;
	action.animated			= self.animated;
	action.withDelay		= self.withDelay;
	action.transition		= self.transition;
	action.modalPresentationStyle = self.modalPresentationStyle;
	return action;
}


#pragma mark -

-(void) dealloc {
	[URLPath release]; URLPath = nil;
	[parentURLPath release]; parentURLPath = nil;
	[query release]; query = nil;
	[super dealloc];
}

@end
