
/*!
@file		main.m
@project	___PROJECTNAME___
@copyright	(c) ___YEAR___, ___ORGANIZATIONNAME___
@created	___DATE___ - ___FULLUSERNAME___
*/

#import <UIKit/UIKit.h>

/*!
@function main
@abstract If nil is specified for principalClassName, the value for NSPrincipalClass 
from the Info.plist is used. If there is no NSPrincipalClass key specified, the 
UIApplication class is used. The delegate class will be instantiated using init.
*/
int
main(int argc, char *argv[]) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, @"___PROJECTNAMEASIDENTIFIER___ApplicationDelegate");
	[pool release];
	return retVal;
}
