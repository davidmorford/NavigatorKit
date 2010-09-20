
#import <NavigatorKit/NKUIDevice.h>

@implementation UIDevice (NKSystemVersionValue)

	@dynamic systemVersionNumber;

	-(NSNumber *) systemVersionNumber {
		return [NSNumber numberWithFloat:[[UIDevice currentDevice].systemVersion floatValue]];
	}

@end

#pragma mark -

float 
NKUIDeviceSystemVersionValue() {
	return [[UIDevice currentDevice].systemVersion floatValue];
}

NSNumber * 
NKUIDeviceSystemVersionNumber() {
	return [[UIDevice currentDevice] systemVersionNumber];
}

NSString * 
NKUIDeviceSystemVersionString() {
	return [UIDevice currentDevice].systemVersion;
}

#pragma mark -

BOOL
NKUIDeviceIsPhoneSupported() {
	return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
}

#pragma mark -

BOOL 
NKUIDeviceHasUserIntefaceIdiom() {
	return ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] ? TRUE : FALSE);
}

UIUserInterfaceIdiom 
NKUIDeviceUserIntefaceIdiom() {
	return ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] ? [[UIDevice currentDevice] userInterfaceIdiom] : UIUserInterfaceIdiomPhone);
}
