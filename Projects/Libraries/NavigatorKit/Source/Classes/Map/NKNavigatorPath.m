
#import <NavigatorKit/NKNavigatorPath.h>
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKNavigatorAction.h>
#import <NavigatorKit/NKNavigatorMap.h>

@implementation NSObject (NKNavigatorPath)

@dynamic URLValue;

-(NSString *) URLValue {
	return [[NKNavigator navigator].navigationMap URLForObject:self];
}

-(NSString *) URLValueWithName:(NSString *)name {
	return [[NKNavigator navigator].navigationMap URLForObject:self withName:name];
}

-(NKNavigatorAction *) navigationAction {
	NKNavigatorAction *result = [NKNavigatorAction actionWithURLPath:[[NKNavigator navigator].navigationMap URLForObject:self]];
	result.query = [NSDictionary dictionaryWithObject:self forKey:@"object"];
	return result;
}

-(NKNavigatorAction *) navigationActionWithName:(NSString *)aName {
	NKNavigatorAction *result = [NKNavigatorAction actionWithURLPath:[[NKNavigator navigator].navigationMap URLForObject:self withName:aName]];
	result.animated = TRUE;
	result.query	= [NSDictionary dictionaryWithObject:self forKey:@"object"];
	return result;
}

@end

#pragma mark -

@implementation NSString (NKNavigatorPath)

-(id) objectValue {
	return [[NKNavigator navigator].navigationMap objectForURL:self];
}

-(void) openURL {
	NKNavigatorAction *action = [[NKNavigatorAction alloc] initWithURLPath:self];
	action.animated = TRUE;
	[[NKNavigator navigator] openURLAction:action];
	[action release];
}

-(void) openURLFromButton:(UIView *)button {
	NKNavigatorAction *action = [[NKNavigatorAction alloc] initWithURLPath:self];
	action.animated	= TRUE;
	action.query	= [NSDictionary dictionaryWithObjectsAndKeys:button, @"__target__", nil];
	[[NKNavigator navigator] openURLAction:action];
	[action release];
}

@end
