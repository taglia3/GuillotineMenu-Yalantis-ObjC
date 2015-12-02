//
//  TableViewCell.m
//  GuillotineMenuSample
//
//  Created by Tigielle on 02/12/15.
//  Copyright © 2015 Matteo Tagliafico. All rights reserved.
//

#import "TableViewCell.h"

#define cellMargin 10.0

@implementation TableViewCell

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.layer.cornerRadius = 5.0;
    self.backgroundColor = [UIColor colorWithRed:61.0 / 255.0 green:58.f / 255.f blue:75.f / 255.f alpha:1];
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x = cellMargin;
    frame.size.width -= 2 * cellMargin;
    [super setFrame:frame];
}

@end
