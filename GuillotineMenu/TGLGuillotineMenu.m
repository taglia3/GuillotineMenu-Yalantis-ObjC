//
//  TGLGuillotineMenu.m
//  GuillotineMenuSample
//
//  Created by Tigielle on 02/12/15.
//  Copyright © 2015 Matteo Tagliafico. All rights reserved.
//

#import "TGLGuillotineMenu.h"

@implementation TGLGuillotineMenu

@synthesize menuButton, menuColor, menuTitles, imagesTitles;

-(id)initWithFrame:(CGRect)frame MenuButton:(UIButton *)button MenuTitles:(NSArray *)titles andImagesTitles:(NSArray *)imgTitles{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.menuButton = button;
        self.menuTitles = titles;
        self.imagesTitles = imgTitles;
        
        self.menuColor = [UIColor colorWithRed:65.0 / 255.0 green:62.f / 255.f blue:79.f / 255.f alpha:1];
        self.backgroundColor = self.menuColor;
        
        screenW = [[UIScreen mainScreen] bounds].size.width;
        screenH = [[UIScreen mainScreen] bounds].size.height;
        
        isOpen = YES;
        supportBoundaryAdded = NO;
        
        oldAngle        = 0.0;
        currentAngle    = 0.0;
    }
    
    return  self;
}

-(void)drawRect:(CGRect)rect{
    
    // - Setup Menu
    [self setupMenu];
    
    // - Setup UiKit Dynamics
    [self initAnimation];
}

-(void)setupMenu{
    
    navBarH     = 64.0;
    statusBarH  = 20.0;
    
    puntoAncoraggio = CGPointMake((navBarH/2.0),(navBarH/2.0));
    
    
    //menuView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenW, screenH)];
    self.backgroundColor = menuColor;
    self.alpha = 0.0;
    //[self addSubview:menuView];
    
    
    // - Menu Button
    
    float tableViewMarginTop = 50.0;
    float tableViewW = 200.0;
    
    menuTableView = [[UITableView alloc ]initWithFrame:CGRectMake((screenW - tableViewW)/2, tableViewMarginTop + navBarH, tableViewW, screenH - 200.0 - tableViewMarginTop)];
    menuTableView.center = self.center;
    menuTableView.backgroundColor = [UIColor clearColor];
    menuTableView.delegate = self;
    menuTableView.dataSource = self;
    [menuTableView setSeparatorColor:[UIColor clearColor]];
    menuTableView.alpha = 0.0;
    [self addSubview:menuTableView];
    
}

-(void)initAnimation{
    
    // - Dynamic Animator
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
    animator.delegate = self;
    
    
    // - Gravity Behavior
    gravity = [[UIGravityBehavior alloc] initWithItems:@[self]];
    
    
    // - Item Behavior
    UIDynamicItemBehavior* itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    itemBehaviour.elasticity = 0.5;
    itemBehaviour.resistance = 1.5;
    itemBehaviour.allowsRotation = YES;
    [animator addBehavior:itemBehaviour];
    
    
    // - Collision Behavior
    collision = [[UICollisionBehavior alloc] initWithItems:@[self]];
    collision.collisionDelegate = self;
    [collision addBoundaryWithIdentifier:@"Collide End" fromPoint:CGPointMake(-2, screenH/2.0) toPoint:CGPointMake(-2, screenH)];
    [collision addBoundaryWithIdentifier:@"Collide Start" fromPoint:CGPointMake(screenH/2,-screenW + navBarH) toPoint:CGPointMake(screenH, -screenW + navBarH)];
    [animator addBehavior:collision];
    
    
    // - Attachment Behavior
    UIOffset offset = UIOffsetMake(-self.superview.bounds.size.width/2 + puntoAncoraggio.x , -self.superview.bounds.size.height/2 + puntoAncoraggio.y);
    attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self offsetFromCenter:offset attachedToAnchor:puntoAncoraggio];
    [animator addBehavior:attachmentBehavior];
    
    
    // - Push Init
    pushInit = [[UIPushBehavior alloc] initWithItems:@[self] mode:UIPushBehaviorModeContinuous];
    CGVector vector = CGVectorMake(1000, 0);
    pushInit.pushDirection = vector;
    UIOffset offsetPush = UIOffsetMake(0, screenH/2);
    [pushInit setTargetOffsetFromCenter:offsetPush forItem:self];
    [animator addBehavior:pushInit];
    
    
    // -
    collision.action =  ^{
        
        CGFloat radians = atan2( self.transform.b, self.transform.a);
        CGFloat degrees = radians * (180 / M_PI );
        
        currentAngle = radians;
        
        if(!isPresentedFirst){
            currentAngle = -M_PI_2;
            CABasicAnimation *rota = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            rota.duration = 0.001;
            rota.autoreverses = NO;
            rota.removedOnCompletion = NO;
            rota.fillMode = kCAFillModeForwards;
            rota.fromValue = [NSNumber numberWithFloat: oldAngle];
            rota.toValue = [NSNumber numberWithFloat: currentAngle ];
            [self.menuButton.layer addAnimation: rota forKey: @"rotation"];
            oldAngle = currentAngle;
        }else if(currentAngle != oldAngle){
            
         //   NSLog(@"%f", degrees);
            
            CABasicAnimation *rota = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            rota.duration = 0.01;
            rota.autoreverses = NO;
            rota.removedOnCompletion = NO;
            rota.fillMode = kCAFillModeForwards;
            rota.fromValue = [NSNumber numberWithFloat: oldAngle];
            rota.toValue = [NSNumber numberWithFloat: currentAngle ];
            [self.menuButton.layer addAnimation: rota forKey: @"rotation"];
            oldAngle = currentAngle;
        }
    };
    
    
}

-(BOOL)isOpen{
    return isOpen;
}


-(void)switchMenuState{
    
    NSLog(@"Menu Button Pressed");
    
    if (isOpen) {
        [self dismissMenu];
    }else{
        [self openMenu];
    }
}

-(void)openMenu{
    
    id<TGLGuillotineMenuDelegate> strongDelegate = self.delegate;
    
    
    if ([strongDelegate respondsToSelector:@selector(menuDidOpen)]) {
        [strongDelegate menuDidOpen];
    }
    
    
    // - Menu Table
    [UIView animateWithDuration:0.2 animations:^{
        menuTableView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
    [collision removeBoundaryWithIdentifier:@"Collide Right"];
    supportBoundaryAdded = NO;
    [animator addBehavior:gravity];
    
    
    // - Push Open
    pushOpen = [[UIPushBehavior alloc] initWithItems:@[self] mode:UIPushBehaviorModeContinuous];
    CGVector vectorOpen = CGVectorMake(0, 1500.0);
    pushOpen.pushDirection = vectorOpen;
    [animator addBehavior:pushOpen];
    
    isOpen = YES;
}

-(void)dismissMenu{
    
    id<TGLGuillotineMenuDelegate> strongDelegate = self.delegate;
    
    
    if ([strongDelegate respondsToSelector:@selector(menuDidClose)]) {
        [strongDelegate menuDidClose];
    }
    
    [animator removeBehavior:pushOpen];
    
    // - Push Init
    pushInit = [[UIPushBehavior alloc] initWithItems:@[self] mode:UIPushBehaviorModeInstantaneous];
    CGVector vector = CGVectorMake(500, 0);
    pushInit.pushDirection = vector;
    UIOffset offsetPush = UIOffsetMake(0, screenH/2);
    [pushInit setTargetOffsetFromCenter:offsetPush forItem:self];
    [animator addBehavior:pushInit];
    
    isOpen = NO;
}


- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    
    
    NSString *identifierString = [NSString stringWithFormat:@"%@", identifier];
    
    if([identifierString isEqualToString:@"Collide Start"]){
        
        if(!supportBoundaryAdded){
            
            float offsetBounce = 0.0;
            [collision addBoundaryWithIdentifier:@"Collide Right" fromPoint:CGPointMake(screenH/2, navBarH + offsetBounce) toPoint:CGPointMake(screenH, navBarH + offsetBounce)];
            supportBoundaryAdded = YES;
        }
        
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1.0;
        } completion:nil];
        
        
        [animator removeBehavior:pushInit];
        isOpen = NO;
        
        if(!isPresentedFirst){
            
            isPresentedFirst = YES;
        }
        
        
        // - Menu Table
        [UIView animateWithDuration:0.1 animations:^{
            menuTableView.alpha = 0.0;
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCell"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:19.0];
    cell.textLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.imagesTitles objectAtIndex:indexPath.row]]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(!isOpen)
        return;
    
    [menuTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    id<TGLGuillotineMenuDelegate> strongDelegate = self.delegate;
    
    
    if ([strongDelegate respondsToSelector:@selector(selectedMenuItemAtIndex:)]) {
        [strongDelegate selectedMenuItemAtIndex:indexPath.row];
    }
    
    [self dismissMenu];
}

@end
