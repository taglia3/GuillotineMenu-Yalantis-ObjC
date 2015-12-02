//
//  TGLSampleViewController.m
//  GuillotineMenuSample
//
//  Created by Tigielle on 02/12/15.
//  Copyright © 2015 Matteo Tagliafico. All rights reserved.
//

#import "TGLSampleViewController.h"

@interface TGLSampleViewController ()

@end

@implementation TGLSampleViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.parentViewController.navigationItem.title = @"NORMAL";
   
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    self.view.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
