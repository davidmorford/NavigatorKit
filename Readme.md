
# NavigatorKit

Based on Three20 TTNavigator source and UXKit UXNavigator fork source, fully supports iOS 3.2 and 4.0 including iPad user interface idioms with either UISplitViewController or MGSplitViewController.


## iPad UI Idiom Split View Navigator Screenshots

[![](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPad-Master-Left.png)](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPad-Master-Left.png)
[![](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPad-Master-Right.png)](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPad-Master-Right.png)
[![](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPad-Master-Hidden.png)](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPad-Master-Hidden.png)
[![](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPad-Master-Hidden.png)](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPad-Horizontal-Orientation.png)
[![](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPad-SplitDivider.png)](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPad-SplitDivider.png)
[![](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPad-Modal.png)](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPad-Modal.png)

## iPhone UI Idiom Navigator Screenshots

[![](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPhone.png)](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPhone.png)
[![](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPhone-OpenIn.png)](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPhone-OpenIn.png)
[![](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPhone-UTIandFileSharing.png)](http://github.com/davidmorford/NavigatorKit/raw/master/Documents/Screenshots/iPhone-UTIandFileSharing.png)


## What's New / Better

* Split View Navigator is a subclass of the Navigator class. 
* NKSplitViewNavigator Either UISplitViewController or MGSplitViewController (with all the associated animated goodness) work.
* Classes with **URL** in the name, URLMap and URLAction, are now NavigatorMap and NavigatorAction.
* Support for iPad modal presentation style and popover user interface idioms.
* Removal of most convenience functions including geometry and orientation.


## What's Different
* Garbage collection replaced with an NSProxy based pattern.
* Keyboard handling removed from UIViewController category.
* UINavigationController category method moved into UINavigationController subclass.
* Remove method chaining convention on Navigator Actions.
* View controller persistence removed in favour of iOS 4 and later multitasking.
* Class heirarchy compacted and refactored.
* Class overhaul based on LLVM/Clang 1.5 new compiler flags. 
  * Ivars moved from headers to class extensions in the implementation files and will away soon in favour of @sythensize or straight @property decls with 2.0 runtime ABI.


## Documentation

I'm working on a documentation set of the classes and an article on how to compose and design your application architecture the Navigator. For now, consult Jeff's excellent article on URL-based navigation with TTNavigator.

1. [URL-based navigation on Three20.info](http://Three20.info/ui/navigation)


### Classes

* NKNavigator

  * NKSplitViewNavigator

  * NKUISplitViewNavigator

* NKNavigatorAction

* NKNavigatorMap

* NKNavigatorPattern

* NKSplitViewController

* NKViewController

* NKNavigationController

* NKPopupViewController

* NKViewControllerProxy

* NKActionSheetController

* NKAlertViewController


### Categories

* NKUIDevice

* NKUINavigationController

* NKUISplitViewController

* NKUITabBarController

* NKUIToolbar

* NKUIViewController


## Requirements

The project, via BuildKit xcconfigs, currently works with Xcode 3.2.4 and the use the SDK setting:

  * SDK : iOS 4.1
  * Minimim Deployment Target : 3.2
  * Weak Linked : UIKit.framework
  * Compiler : LLVM/Clang 1.5
  * Compiler Flags :
    * -Xclang -fobjc-nonfragile-abi2
    * -D__IPHONE_OS_VERSION_MIN_REQUIRED=030200


## Known Issues
 
 * Popup alert and action sheet display in TabBars on iPad/iPhone.
 * Better UIPopoverController management.
 * New iOS SDK releases require the SDKROOT value be changed manually for each Xcode project at the **project** level. This will get Simulator and Device SDKs to show up in the Overview drop down (and others) in the Xcode toolbar.  Xcode began ignoring the value set for SDKROOT at the project level with the release of iOS 4.0 SDK, thus requiring this tedious task be done for every Xcode project for each final SDK release with a new iOS version number instead of changing a few characters or the imported Platform-n.n.xcconfig file in Configurations/Platform.xcconfig. Radar issue number : [rdar://8192536](http://openradar.appspot.com/8192536)


## Quick Start

1. Download or clone this repo.

2. Ensure you meet **Requirements** above.

3. Open NavigatorCatalog.xcodeproj and Build. (See Note on Setting SDKROOT in Xcode Project below if simulator or device are missing in your build targets toolbar)

4. Run application.


## Using Xcode Project Template

1. Copy contents of 'Xcode/Project Templates/iOS to '~/Library/Application Support/Developer/Xcode/Project Templates/iOS'.

2. Create new Xcode application project by selecting 'NavigatorKit Universal Application' and creating the project in either the Applications or Catalogs directory of the BuildKit structure. Inside any first level folder of Projects is fine. Applications, Catalogs, Libraries are exemplars and Application projects only need to know the path the root Configurations folder and the root Build folder to reference finder librarys headers and link to static library archives.

3. Double check the SDKROOT.

4. Build and run. Viola.

5. Start making your new applcation with ease.


## Examples

 1. NavigatorCatalog - Universal application showing how to use URL based navigation in the to architect iOS applications and illustrate features of NavigatorKit.
 2. NavigatorKit Universal Application Project Template


## History

### September 2010
- Update Readme, Todo and Licenses.
- Public release.
- Reformat source from 'Dave Normal' (4 space indentation inside @interface and @implemetation for visual structuring) to 'Everyone Normal'.
- New example applicatgion and feature catalog application. 
- New Xcode project templates and incorporated into latest BuildKit layout.

### August 15, 2010 (Internal)
- Remove view controller persistence. Let iOS handle it.
- Incorporate NKSplitViewPopoverButtonDelegate based on Malcolm Crawford's devforums.apple.com posts and Apple source code example.
- Toss out simplistic custom SplitViewController class in favour of kick-ass MGSplitViewController. Thanks Matt!

### June 2010 (Internal)
- Handle model presentation styles based on user interface idiom.
- Deal with iOS 4.0 and Xcode 3.2.4 *ignoring* SDK_ROOT set from .xcconfig on project root.

### March 2010 (Internal)
- Use UINavigationController subclass (Considered a "bad" thing but everyone seems to do it...)
- Remove garbage collection, use NSProxy pattern and remove ALL method swizzling.
- Branch from UXKit into seperate library, selected updates from latest Three20.


## Licenses and Copyright

NavigatorKit is a BSD licensed and originated with the TTNavigator classes of the Three20 library. NavigatorKit includes a mostly umodified version of MGSplitViewController (by Matt Legend Gemmell) as an alternative to UISplitViewController. The full text of the license and links to the licenses covering Three20 (Apache License) and MGSplitViewController (BSD with attribution) is located in Documents/License.md

