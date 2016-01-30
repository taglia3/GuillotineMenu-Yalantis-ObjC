//
//  TGLGuillotineMenu.m
//  GuillotineMenuSample
//
//  Created by Tigielle on 02/12/15.
//  Copyright © 2015 Matteo Tagliafico. All rights reserved.
//

#import "TGLGuillotineMenu.h"

@interface CustomCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation CustomCollectionViewCell

@end

@implementation TGLGuillotineMenu

@synthesize menuButton, menuColor, menuTitles, imagesTitles, viewControllers;

- (id)initWithViewControllers:(NSArray *)vCs MenuTitles:(NSArray *)titles andImagesTitles:(NSArray *)imgTitles {
    
    self = [super init];
    
    if (self) {
        
        isPresentedFirst = NO;
        
        self.viewControllers    = [vCs copy];
        self.menuTitles         = [titles copy];
        self.imagesTitles       = [imgTitles copy];
        
        self.menuColor = [UIColor colorWithRed:65.0 / 255.0 green:62.f / 255.f blue:79.f / 255.f alpha:1];
        
        
        screenW = [[UIScreen mainScreen] bounds].size.width;
        screenH = [[UIScreen mainScreen] bounds].size.height;
        
        isOpen = YES;
        supportBoundaryAdded = NO;
        
        oldAngle        = 0.0;
        currentAngle    = 0.0;
    }
    
    return  self;
}

- (id)initWithViewControllers:(NSArray *)vCs MenuTitles:(NSArray *)titles andImagesTitles:(NSArray *)imgTitles andStyle:(TGLGuillotineMenuStyle)style {
	
	self = [self initWithViewControllers:vCs MenuTitles:titles andImagesTitles:imgTitles];
	
	self.menuStyle = style;
	
	return self;
}

- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UINavigationBar* navBar = self.navigationController.navigationBar;
    [navBar setTranslucent:YES];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [navBar setBackgroundImage:[UIImage imageNamed:@"patternNav"] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[[UIImage alloc] init]];
    
    // - Setup Menu
    [self setupMenu];
    
    // - Setup UiKit Dynamics
    [self initAnimation];
    
    [self presentController:[self.viewControllers objectAtIndex:0]];
    self.navigationItem.title = [self.menuTitles objectAtIndex:0];
}

- (void)setupMenu {
    
    navBarH     = 64.0;
    statusBarH  = 20.0;
    
    puntoAncoraggio = CGPointMake((navBarH/2.0),(navBarH/2.0));
    
    
    menuView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenW, screenH)];
    menuView.backgroundColor = menuColor;
    menuView.alpha = 0.0;
    [self.view addSubview:menuView];
    
    
    // - Menu Button
    float buttonMenuW = 15.0;
    float buttonMenuH = 10.0;
    
    self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonMenuW, buttonMenuH)];
    [self.menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(switchMenuState) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
    
    float tableViewMarginTop = 50.0;
    float tableViewW = 200.0;
	
	if (self.menuStyle == TGLGuillotineMenuStyleCollection) {
		 UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
		menuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(40, 80, screenW - 80, screenH - 164) collectionViewLayout:layout];
		menuCollectionView.center = self.view.center;
		menuCollectionView.backgroundColor = [UIColor clearColor];
		menuCollectionView.delegate = self;
		menuCollectionView.dataSource = self;
		menuCollectionView.alpha = 0.0;
		[menuCollectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
		[menuView addSubview:menuCollectionView];
	}
	else {
		menuTableView = [[UITableView alloc] initWithFrame:CGRectMake((screenW - tableViewW)/2, tableViewMarginTop + navBarH, tableViewW, screenH - 200.0 - tableViewMarginTop)];
		menuTableView.center = self.view.center;
		menuTableView.backgroundColor = [UIColor clearColor];
		menuTableView.delegate = self;
		menuTableView.dataSource = self;
		[menuTableView setSeparatorColor:[UIColor clearColor]];
		menuTableView.alpha = 0.0;
		[menuView addSubview:menuTableView];
	}
	
}

- (void)initAnimation {
    
    // - Dynamic Animator
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    animator.delegate = self;
    
    
    // - Gravity Behavior
    gravity = [[UIGravityBehavior alloc] initWithItems:@[menuView]];
    
    
    // - Item Behavior
    UIDynamicItemBehavior* itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[menuView]];
    itemBehaviour.elasticity = 0.53;
    itemBehaviour.resistance = 1.2;
    itemBehaviour.allowsRotation = YES;
    [animator addBehavior:itemBehaviour];
    
    
    // - Collision Behavior
    collision = [[UICollisionBehavior alloc] initWithItems:@[menuView]];
    collision.collisionDelegate = self;
    [collision addBoundaryWithIdentifier:@"Collide End" fromPoint:CGPointMake(-2, screenH/2.0) toPoint:CGPointMake(-2, screenH)];
    [collision addBoundaryWithIdentifier:@"Collide Start" fromPoint:CGPointMake(screenH/2,-screenW + navBarH) toPoint:CGPointMake(screenH, -screenW + navBarH)];
    [animator addBehavior:collision];
    
    
    // - Attachment Behavior
    UIOffset offset = UIOffsetMake(-self.view.bounds.size.width/2 + puntoAncoraggio.x , -self.view.bounds.size.height/2 + puntoAncoraggio.y);
    attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:menuView offsetFromCenter:offset attachedToAnchor:puntoAncoraggio];
    [animator addBehavior:attachmentBehavior];
    
    
    // - Push Init
    pushInit = [[UIPushBehavior alloc] initWithItems:@[menuView] mode:UIPushBehaviorModeContinuous];
    CGVector vector = CGVectorMake(1000, 0);
    pushInit.pushDirection = vector;
    UIOffset offsetPush = UIOffsetMake(0, screenH/2);
    [pushInit setTargetOffsetFromCenter:offsetPush forItem:menuView];
    [animator addBehavior:pushInit];
    
    
    // -
    collision.action =  ^{
        
        CGFloat radians = atan2( menuView.transform.b, menuView.transform.a);
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
        }
		else if(currentAngle != oldAngle){
            
//            NSLog(@"%f", degrees);
			
            CABasicAnimation *rota = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            rota.duration = 0.01;
            rota.autoreverses = NO;
            rota.removedOnCompletion = NO;
            rota.fillMode = kCAFillModeForwards;
            rota.fromValue = [NSNumber numberWithFloat: oldAngle];
            rota.toValue = [NSNumber numberWithFloat: currentAngle ];
            [self.menuButton.layer addAnimation: rota forKey: @"rotation"];
            oldAngle = currentAngle;
            
            self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithWhite:1.0 alpha:((-degrees)/90)]};
        }
    };
    
    
}

- (BOOL)isOpen{
    return isOpen;
}


- (void)switchMenuState{
    
    NSLog(@"Menu Button Pressed");
    
    if (isOpen) {
        [self dismissMenu];
    }else{
        [self openMenu];
    }
}

- (void)openMenu{
    
    id<TGLGuillotineMenuDelegate> strongDelegate = self.delegate;
    
    
    if ([strongDelegate respondsToSelector:@selector(menuDidOpen)]) {
        [strongDelegate menuDidOpen];
    }
    
    
    // - Menu Table
    [UIView animateWithDuration:0.15 animations:^{
		if (self.menuStyle == TGLGuillotineMenuStyleCollection)
			menuCollectionView.alpha = 1.0;
		else
			menuTableView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
    [collision removeBoundaryWithIdentifier:@"Collide Right"];
    supportBoundaryAdded = NO;
    [animator addBehavior:gravity];
    
    
    // - Push Open
    pushOpen = [[UIPushBehavior alloc] initWithItems:@[menuView] mode:UIPushBehaviorModeContinuous];
    CGVector vectorOpen = CGVectorMake(0, 2200.0);
    pushOpen.pushDirection = vectorOpen;
    [animator addBehavior:pushOpen];
    
    isOpen = YES;
}

- (void)dismissMenu{
    
    id<TGLGuillotineMenuDelegate> strongDelegate = self.delegate;
    
    
    if ([strongDelegate respondsToSelector:@selector(menuDidClose)]) {
        [strongDelegate menuDidClose];
    }
    
    [animator removeBehavior:pushOpen];
    
    // - Push Init
    pushInit = [[UIPushBehavior alloc] initWithItems:@[menuView] mode:UIPushBehaviorModeInstantaneous];
    CGVector vector = CGVectorMake(800, 100);
    pushInit.pushDirection = vector;
    UIOffset offsetPush = UIOffsetMake(0, screenH/2);
    [pushInit setTargetOffsetFromCenter:offsetPush forItem:menuView];
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
            menuView.alpha = 1.0;
        } completion:nil];
        
        
        [animator removeBehavior:pushInit];
        isOpen = NO;
        
        if(!isPresentedFirst){
            
            isPresentedFirst = YES;
        }
        
        
        // - Menu Table
        [UIView animateWithDuration:0.1 animations:^{
			if (self.menuStyle == TGLGuillotineMenuStyleCollection)
				menuCollectionView.alpha = 0.0;
			else
				menuTableView.alpha = 0.0;
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuTitles.count;
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
    cell.textLabel.font = [UIFont fontWithName:@"Futura-Medium" size:19.f];
    cell.textLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.imagesTitles objectAtIndex:indexPath.row]]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(!isOpen)
        return;
    
    [menuTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    id<TGLGuillotineMenuDelegate> strongDelegate = self.delegate;
    
    
    if ([strongDelegate respondsToSelector:@selector(selectedMenuItemAtIndex:)]) {
        [strongDelegate selectedMenuItemAtIndex:indexPath.row];
    }
    
    [self presentController:[self.viewControllers objectAtIndex:indexPath.row]];
    self.navigationItem.title = [self.menuTitles objectAtIndex:indexPath.row];
    [self dismissMenu];
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.menuTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
	
	if (cell == nil){
		cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
	}
	
	cell.backgroundColor = [UIColor clearColor];

	CGFloat width = cell.bounds.size.width;
	CGFloat height = cell.bounds.size.height;
	
	if (!cell.imageView) {
		cell.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 2*height/3)];
		[cell.imageView setContentMode:UIViewContentModeBottom];
		[cell.imageView setClipsToBounds:YES];
		[cell.contentView addSubview:cell.imageView];
	}
	
	if (!cell.textLabel) {
		cell.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2*height/3, width, height/3)];
		cell.textLabel.textColor = [UIColor whiteColor];
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.textLabel.font = [UIFont fontWithName:@"Futura-Medium" size:17.f];
		[cell.contentView addSubview:cell.textLabel];
	}
	
	cell.imageView.image = [UIImage imageNamed:[self.imagesTitles objectAtIndex:indexPath.row]];
	cell.textLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
	
	return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	if(!isOpen)
		return;
	
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	
	id<TGLGuillotineMenuDelegate> strongDelegate = self.delegate;
	
	
	if ([strongDelegate respondsToSelector:@selector(selectedMenuItemAtIndex:)]) {
		[strongDelegate selectedMenuItemAtIndex:indexPath.row];
	}
	
	[self presentController:[self.viewControllers objectAtIndex:indexPath.row]];
	self.navigationItem.title = [self.menuTitles objectAtIndex:indexPath.row];
	[self dismissMenu];
	
}

#pragma mark - Collection view delegate flow layout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat size = (screenW - 80 - 24)/2;
	return CGSizeMake(size, size);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 24.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 24.f;
}

#pragma mark - Presentation Logic

- (void)presentController:(UIViewController*)controller{
    
    if(self.currentViewController){
        [self removeCurrentViewController];
    }
    
    [self addChildViewController:controller];
    
    controller.view.frame = self.view.frame;
    
    [self.view insertSubview:controller.view belowSubview:menuView];

    
    self.currentViewController = controller;
    
    //4. Complete the add flow calling the function didMoveToParentViewController
    [controller didMoveToParentViewController:self];
    
}


- (void)removeCurrentViewController{
    
    [self.currentViewController willMoveToParentViewController:nil];
    
    [self.currentViewController.view removeFromSuperview];
    
    [self.currentViewController removeFromParentViewController];
}

@end
