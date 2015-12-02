//
//  TGLGuillotineMenu.h
//  GuillotineMenuSample
//
//  Created by Tigielle on 02/12/15.
//  Copyright © 2015 Matteo Tagliafico. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TGLGuillotineMenuDelegate;

@interface TGLGuillotineMenu : UIView

@property (nonatomic, weak) id<TGLGuillotineMenuDelegate> delegate;

@end

@protocol TGLGuillotineMenuDelegate <NSObject>

- (void)menuDidOpen;
- (void)menuDidClose;

@end
