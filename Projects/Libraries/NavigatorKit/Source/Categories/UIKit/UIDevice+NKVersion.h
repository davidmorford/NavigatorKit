
/*!
@project    NavigatorKit
@header     UIDevice+NKVersion.h
@changes	(c) 2009 - 2011, Dave Morford
*/

#import <UIKit/UIKit.h>

@interface UIDevice (NKVersion)
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
NKUIDeviceHasUserIntefaceIdiom();

UIUserInterfaceIdiom 
NKUIDeviceUserIntefaceIdiom();
