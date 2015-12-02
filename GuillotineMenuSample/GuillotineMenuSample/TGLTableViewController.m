//
//  ViewController.m
//  GuillotineMenuSample
//
//  Created by Tigielle on 02/12/15.
//  Copyright © 2015 Matteo Tagliafico. All rights reserved.
//

#import "TGLTableViewController.h"
#import "TableViewCell.h"

static NSString* reuseIdentifier = @"CellPH";
static const CGFloat cellHeight = 210;
static const CGFloat cellSpacing = 20;

@interface TGLTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation TGLTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.parentViewController.navigationItem.title = @"TABLE";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    tableView.backgroundColor = [UIColor colorWithRed:44.0 / 255.0 green:42.f / 255.f blue:54.f / 255.f alpha:1];
    tableView.separatorColor = [UIColor clearColor];
    tableView.dataSource   = self;
    tableView.delegate     = self;
    [self.view addSubview:tableView];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = (TableViewCell*) [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20.0, cellHeight)];
    
    if(indexPath.section%2 == 0)
        imageView.image = [UIImage imageNamed:@"content_1"];
    else
        imageView.image = [UIImage imageNamed:@"content_2"];
    
    [cell.contentView addSubview:imageView];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return cellSpacing;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}


@end
