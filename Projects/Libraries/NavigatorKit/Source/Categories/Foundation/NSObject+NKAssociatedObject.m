
#import <NavigatorKit/NSObject+NKAssociatedObject.h>

@implementation NSObject (NKAssociatedObject)

-(void) associateValue:(id)aValue withKey:(NSString *)aKey {
	objc_setAssociatedObject(self, aKey, aValue, NKAssociationPolicyRetainNonatomic);
}

-(void) associateValue:(id)aValue withKey:(NSString *)aKey policy:(NKAssociationPolicy)aPolicy {
	objc_setAssociatedObject(self, aKey, aValue, aPolicy);
}

-(id) associatedValueForKey:(NSString *)aKey {
	return objc_getAssociatedObject(self, aKey);
}

-(void) removeAssociatedValueForKey:(NSString *)aKey {
	[self associateValue:nil withKey:aKey policy:NKAssociationPolicyAssign];
}

@end
