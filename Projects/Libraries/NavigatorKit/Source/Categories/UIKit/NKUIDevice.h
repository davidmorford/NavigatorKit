
#import <UIKit/UIKit.h>

@interface UIDevice (NKSystemVersionValue)
@property (nonatomic, readonly) NSNumber *systemVersionNumber;
@end

#pragma mark -

float 
NKUIDeviceSystemVersionValue();

NSString * 
NKUIDeviceSystemVersionString();

NSNumber * 
NKUIDeviceSystemVersionNumber();

#pragma mark -

BOOL 
NKUIDeviceIsPhoneSupported();

#pragma mark -

BOOL 
NKUIDeviceHasUserIntefaceIdiom();

UIUserInterfaceIdiom 
NKUIDeviceUserIntefaceIdiom();
