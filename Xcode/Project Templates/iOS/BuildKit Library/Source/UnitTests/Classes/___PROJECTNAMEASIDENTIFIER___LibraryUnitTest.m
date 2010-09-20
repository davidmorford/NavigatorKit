
/*!
@header		___PROJECTNAMEASIDENTIFIER___Library.h
@project	___PROJECTNAME___
@author		___FULLUSERNAME___
@copyright	(c) ___YEAR___, ___ORGANIZATIONNAME___
@created	___DATE___
*/

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import <___PROJECTNAMEASIDENTIFIER___/___PROJECTNAMEASIDENTIFIER___.h>

@interface ___PROJECTNAMEASIDENTIFIER___LibraryUnitTest : SenTestCase {

}

	-(void) testMath;

@end

#pragma mark -

@implementation ___PROJECTNAMEASIDENTIFIER___LibraryUnitTest

	-(void) testMath {
		STAssertTrue((1 + 1) == 2, @"Compiler isn't feeling well today :-(" );
	}

@end
