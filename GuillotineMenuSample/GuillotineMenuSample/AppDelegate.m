//
//  AppDelegate.m
//  GuillotineMenuSample
//
//  Created by Tigielle on 02/12/15.
//  Copyright © 2015 Matteo Tagliafico. All rights reserved.
//

#import "AppDelegate.h"

#import "TGLTableViewController.h"
#import "TGLSampleViewController.h"

#import "TGLGuillotineMenu.h"

@interface AppDelegate () <TGLGuillotineMenuDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Guillotine Menu Delegate

-(void)selectedMenuItemAtIndex:(NSInteger)index{
    
    NSLog(@"Selected menu item at index %ld", index);
}

-(void)menuDidOpen{
    NSLog(@"Menu did Open");
}

-(void)menuDidClose{
    NSLog(@"Menu did Close");
}

@end
