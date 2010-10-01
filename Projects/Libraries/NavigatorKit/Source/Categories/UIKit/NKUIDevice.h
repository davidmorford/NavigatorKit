
/*!
@project    NavigatorKit
@header     NKUIDevice.h
@changes	(c) 2009-2010, Dave Morford
*/

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
NKUIDeviceHasUserIntefaceIdiom();

UIUserInterfaceIdiom 
NKUIDeviceUserIntefaceIdiom();
