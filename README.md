# GuillotineMenu Yalantis objc Version

[![Build Status](https://travis-ci.org/farshidce/GuillotineMenu-Yalantis-ObjC-Version.png?branch=mastter)](https://travis-ci.org/farshidce/GuillotineMenu-Yalantis-ObjC-Version)

This is the Objective-C Version of GuillotineMenu made by Yalantis https://github.com/Yalantis/GuillotineMenu

![Preview](https://d13yacurqjgara.cloudfront.net/users/495792/screenshots/2018249/draft_06.gif)

#Usage
The easiest way to use this cool menu is to instantiate the `TGLGuillotineMenu` in your `AppDelegate` and, then make it the `rootController` of a `UINavigationController` instance.

```objective-c
TGLTableViewController *vc01 = [[TGLTableViewController alloc] init];
TGLSampleViewController *vc02 = [[TGLSampleViewController alloc] init];
TGLTableViewController *vc03 = [[TGLTableViewController alloc] init];
TGLSampleViewController *vc04 = [[TGLSampleViewController alloc] init];

NSArray *vcArray        = [[NSArray alloc] initWithObjects:vc01, vc02, vc03, vc04, nil];
NSArray *titlesArray    = [[NSArray alloc] initWithObjects:@"PROFILE", @"FEED", @"ACTIVITY", @"SETTINGS", nil];
NSArray *imagesArray   = [[NSArray alloc] initWithObjects:@"ic_profile", @"ic_feed", @"ic_activity", @"ic_settings", nil];

TGLGuillotineMenu *menuVC = [[TGLGuillotineMenu alloc] initWithViewControllers:vcArray MenuTitles:titlesArray andImagesTitles:imagesArray];
menuVC.delegate = self;

UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:menuVC];
```

#Installation
Manual installation. Just copy GuillotineMenu folder to your project. Will be available on cocoapods soon.

# Note
This is my first attempt to make a simple Objective-C version of Yalantis control. From now I will update this control to make this an awesome iOS menu.
Feel free to contribute!

