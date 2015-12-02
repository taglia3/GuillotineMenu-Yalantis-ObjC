//
//  TGLGuillotineMenu.h
//  GuillotineMenuSample
//
//  Created by Tigielle on 02/12/15.
//  Copyright © 2015 Matteo Tagliafico. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TGLGuillotineMenuDelegate;

@interface TGLGuillotineMenu : UIView <UITableViewDataSource, UITableViewDelegate, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate>{
    
    float screenW;
    float screenH;
    
    float navBarH;
    float statusBarH;
    
    // - Menu Button Rotation
    float oldAngle;
    float currentAngle;
    
    UIView      *menuView;
    UIButton    *menuButton;
    UITableView *menuTableView;
    
    
    BOOL isOpen;
    BOOL supportBoundaryAdded;
    
    UIPushBehavior *pushInit;
    UIPushBehavior *pushOpen;
    UIAttachmentBehavior *attachmentBehavior;
    
    // - Dynamics
    UIDynamicAnimator   *animator;
    UICollisionBehavior *collision;
    UIGravityBehavior   *gravity;
    
    CGPoint puntoAncoraggio;
    
    BOOL isPresentedFirst;
    
}


@property(nonatomic, strong) UIButton *menuButton;

@property (nonatomic, strong) UIColor   *menuColor;

@property (nonatomic, weak) id<TGLGuillotineMenuDelegate> delegate;

// -Init method
-(id)initWithFrame:(CGRect)frame MenuButton:(UIButton*)button;

// -
-(BOOL)isOpen;

// -
-(void)switchMenuState;
-(void)openMenu;
-(void)dismissMenu;

@end



@protocol TGLGuillotineMenuDelegate <NSObject>

- (void)menuDidOpen;
- (void)menuDidClose;

@end
