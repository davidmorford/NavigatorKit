
#import <NavigatorKit/UIApplication+NKNavigator.h>
#import <NavigatorKit/NSObject+NKAssociatedObject.h>

static NSString * const NKUIApplicationNavigatorKey = @"NKUIApplicationNavigatorKey";

@implementation UIApplication (NKNavigator)

-(NKNavigator *) applicationNavigator {
	return [self associatedValueForKey:NKUIApplicationNavigatorKey];
}

-(void) setApplicationNavigator:(NKNavigator *)aNavigator {
	if ([self associatedValueForKey:NKUIApplicationNavigatorKey]) {
		[self associateValue:nil 
					 withKey:NKUIApplicationNavigatorKey 
					  policy:NKAssociationPolicyAssign];
	}
	if (aNavigator) {
		[self associateValue:aNavigator 
					 withKey:NKUIApplicationNavigatorKey 
					  policy:NKAssociationPolicyRetainNonatomic];
	}
}

@end
