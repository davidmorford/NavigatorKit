
/*!
@project    NavigatorKit
@header     NKURLNavigationPattern.h
@copyright  (c) 2009-2010, Three20
@changes    (c) 2009-2010, Dave Morford
*/

#import <Foundation/Foundation.h>
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKNavigatorMap.h>

extern NSString* const NKUniversalURLPattern;

typedef NSUInteger NKNavigatorArgumentType;
enum {
	NKNavigatorArgumentTypeNone,
	NKNavigatorArgumentTypePointer,
	NKNavigatorArgumentTypeBool,
	NKNavigatorArgumentTypeInteger,
	NKNavigatorArgumentTypeLongLong,
	NKNavigatorArgumentTypeFloat,
	NKNavigatorArgumentTypeDouble
};

#pragma mark -

@protocol NKURLPatternText <NSObject>
-(BOOL) match:(NSString *)aTextString;
-(NSString *) convertPropertyOfObject:(id)anObject;
@end

#pragma mark -

/*!
@class NKURLNavigationPattern
@superclass NSObject
@abstract
@discussion
*/
@interface NKURLNavigatorPattern : NSObject

@property (nonatomic, copy) NSString *URL;
@property (nonatomic, readonly) NSString *scheme;
@property (nonatomic, readonly) NSInteger specificity;
@property (nonatomic, readonly) Class classForInvocation;
@property (nonatomic, assign) SEL selector;

#pragma mark -

-(void) compileURL;

-(void) setSelectorIfPossible:(SEL)aSelector;
-(void) setSelectorWithNames:(NSArray *)names;

@end

#pragma mark -

@interface NKURLLiteral : NSObject <NKURLPatternText>

@property (nonatomic, copy) NSString *name;

@end

#pragma mark -

@interface NKURLSelector : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, retain) NKURLSelector *next;

#pragma mark -

-(id) initWithName:(NSString *)aName;

-(NSString *) perform:(id)anObject returnType:(NKNavigatorArgumentType)aTeturnType;

@end

#pragma mark -

@interface NKURLWildcard : NSObject <NKURLPatternText>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger argIndex;
@property (nonatomic, assign) NKNavigatorArgumentType argType;
@property (nonatomic, retain) NKURLSelector *selector;

#pragma mark -

-(void) deduceSelectorForClass:(Class)cls;

@end

#pragma mark -


/*!
@class NKURLGeneratorPattern
@superclass NKURLNavigationPattern
@abstract
@discussion
*/
@interface NKURLGeneratorPattern : NKURLNavigatorPattern

@property (nonatomic, assign) Class targetClass;

#pragma mark -

-(id) initWithTargetClass:(Class)aTargetClass;

#pragma mark -

-(void) compile;
-(NSString *) generateURLFromObject:(id)object;

@end

#pragma mark -

/*!
@class NKNavigationPattern
@superclass NKURLNavigationPattern
@abstract
@discussion
*/
@interface NKNavigatorPattern : NKURLNavigatorPattern

@property (nonatomic, assign) Class targetClass;
@property (nonatomic, assign) id targetObject;
@property (nonatomic, assign) NKNavigatorMode navigationMode;
@property (nonatomic, copy) NSString *parentURL;
@property (nonatomic, assign) NSInteger transition;
@property (nonatomic, assign) NSInteger argumentCount;
@property (nonatomic, readonly) BOOL isUniversal;
@property (nonatomic, readonly) BOOL isFragment;
@property (nonatomic, assign) UIModalPresentationStyle modalPresentationStyle;

#pragma mark -

-(id) initWithTarget:(id)aTarget;
-(id) initWithTarget:(id)aTarget mode:(NKNavigatorMode)aNavigationMode;

#pragma mark -

-(void) compile;

-(BOOL) matchURL:(NSURL *)aURL;

-(id) invoke:(id)target withURL:(NSURL *)aURL query:(NSDictionary *)aQuery;
-(id) createObjectFromURL:(NSURL *)aURL query:(NSDictionary *)aQuery /*NS_RETURNS_RETAINED*/;

@end

#pragma mark -

@interface NSString (NKString)
-(NSDictionary *) queryDictionaryUsingEncoding:(NSStringEncoding)encoding;
@end

#pragma mark -

NKNavigatorArgumentType 
NKConvertArgumentType(char argType);

NKNavigatorArgumentType 
NKNavigatorArgumentTypeForProperty(Class cls, NSString *propertyName);
