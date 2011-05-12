
/*!
@project    NavigatorKit
@header     NSObject+NKAssociatedObject.h
@shoutout	Andy Matuschak for the orginial idea.
*/

#import <Foundation/NSObject.h>
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>

@class NSString;

typedef objc_AssociationPolicy NKAssociationPolicy;
enum {
	NKAssociationPolicyAssign = OBJC_ASSOCIATION_ASSIGN,
	NKAssociationPolicyRetainNonatomic = OBJC_ASSOCIATION_RETAIN_NONATOMIC,
    NKAssociationPolicyCopyNonatomic = OBJC_ASSOCIATION_COPY_NONATOMIC,
	NKAssociationPolicyRetain = OBJC_ASSOCIATION_RETAIN,
    NKAssociationPolicyCopy = OBJC_ASSOCIATION_COPY
};

/*!
@category NSObject (NKAssociatedObject)
@abstract 
*/
@interface NSObject (NKAssociatedObject)

-(id) associatedValueForKey:(NSString *)aKey;

/*!
@abstract Retains value
*/
-(void) associateValue:(id)aValue withKey:(NSString *)aKey;

-(void) removeAssociatedValueForKey:(NSString *)aKey;

/*!
@method associateValue:withKey:policy:
@abstract Associated a value and a policy with an object instance.
*/
-(void) associateValue:(id)aValue withKey:(NSString *)aKey policy:(NKAssociationPolicy)aPolicy;

@end
