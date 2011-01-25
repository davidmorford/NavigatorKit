
/*!
@project    NavigatorKit
@header     NKPathUtilities.h
@copyright  (c) 2009, Three20
@copyright  (c) 2009 - 2011, Dave Morford
*/

#import <Foundation/Foundation.h>

/*!
@abstract Returns TRUE if the URL begins with "bundle://" , "documents://" or "temp://"
*/
BOOL 
NKPathIsInternalURL(NSString *URLString);

/*!
@abstract Returns TRUE if the URL begins with "bundle://"
*/
BOOL
NKPathIsBundleURL(NSString *URLString);

/*!
@abstract Returns TRUE if the URL begins with "documents://"
*/
BOOL
NKPathIsDocumentsURL(NSString *URLString);

BOOL
NKPathIsFileURL(NSString *URLString);


#pragma mark -

NSString * 
NKPathForFileInResourceBundle(NSString *resourceFilePath, NSString *bundleName);

NSString * 
NKPathForBundleResource(NSString *bundleResourceFilePath);


#pragma mark -

NSString *
NKPathForFileResource(NSString *bundleFilePath);

/*!
@abstract Returns the documents path concatenated with the given relative path.
*/
NSString *
NKPathForDocumentsResource(NSString *relativePath);


#pragma mark -

NSURL * 
NKPathFileURLForBundleResource(NSString *relativePath);
