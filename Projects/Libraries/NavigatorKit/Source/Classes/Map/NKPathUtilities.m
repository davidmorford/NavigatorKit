
#import <NavigatorKit/NKPathUtilities.h>

BOOL
NKPathIsInternalURL(NSString *aURLString) {
	return NKPathIsBundleURL(aURLString) || NKPathIsDocumentsURL(aURLString) || NKPathIsFileURL(aURLString);
}

BOOL
NKPathIsBundleURL(NSString *aURLString) {
	return [aURLString hasPrefix:@"bundle://"];
}

BOOL
NKPathIsDocumentsURL(NSString *aURLString) {
	return [aURLString hasPrefix:@"documents://"];
}

BOOL
NKPathIsFileURL(NSString *aURLString) {
	return [aURLString hasPrefix:@"file://"];
}

#pragma mark -

NSString * 
NKPathForBundleResource(NSString *bundleResourceFilePath) {
	NSString *mainBundlePath = [[NSBundle mainBundle] resourcePath];
	if (NKPathIsBundleURL(bundleResourceFilePath) == TRUE) {
		NSString *filePath	= [bundleResourceFilePath substringFromIndex:9];
		return [mainBundlePath stringByAppendingPathComponent:filePath];
	}
	return nil;
}

NSString *
NKPathForFileResource(NSString *bundleFilePath) {
	if (NKPathIsFileURL(bundleFilePath) == TRUE) {
		NSString *localFilePath	= [bundleFilePath substringFromIndex:7];
		NSString *mainBundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:localFilePath];
		return mainBundlePath;
	}
	return nil;
}

NSString *
NKPathForDocumentsResource(NSString *filePath) {
	static NSString *documentsPath = nil;
	if (!documentsPath) {
		NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		documentsPath = [[dirs objectAtIndex:0] retain];
	}
	if (NKPathIsDocumentsURL(filePath) == TRUE) {
		NSString *localFilePath	= [filePath substringFromIndex:12];
		return [documentsPath stringByAppendingPathComponent:localFilePath];
	}
	return nil;
}

#pragma mark -

NSString * 
NKPathForFileInResourceBundle(NSString *resourceFilePath, NSString *bundleName) {
	NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
	return [[mainBundlePath stringByAppendingPathComponent:bundleName] stringByAppendingPathComponent:resourceFilePath];
}

NSURL * 
NKPathFileURLForBundleResource(NSString *relativeFilePath) {
	NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
	NSString *fullResourcePath = [mainBundlePath stringByAppendingPathComponent:relativeFilePath];
	return [NSURL fileURLWithPath:fullResourcePath];
}
