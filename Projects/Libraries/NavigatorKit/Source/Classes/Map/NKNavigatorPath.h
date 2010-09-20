
/*!
@project    NavigatorKit
@header     NKNavigatorPath.h
@copyright  (c) 2009-2010, Three20
@copyright  (c) 2009-2010, Dave Morford
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
@category NSObject (NKNavigatorPath)
@abstract
@discussion
*/
@interface NSObject (NKNavigatorPath)

/*!
@abstract Converts the object to a URL using NKNavigatorMap.
*/
@property (nonatomic, readonly) NSString *URLValue;

/*!
@abstract Converts the object to a specially-named URL using NKNavigatorMap.
*/
-(NSString *) URLValueWithName:(NSString *)name;

@end

#pragma mark -

/*!
@category NSString (NKNavigatorPath)
@abstract
@discussion
*/
@interface NSString (NKNavigatorPath)

/*!
@abstract Converts the string to an object using NKNavigatorMap.
*/
-(id) objectValue;

/*!
@abstract Opens a URL with the string using NKNavigatorMap.
*/
-(void) openURL;
-(void) openURLFromButton:(UIView *)button;

@end
