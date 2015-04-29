//
//  OWLabel.m
//  OWKit
//
//  Created by mac on 15/4/16.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import "OWLabel.h"

@implementation OWLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame withInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self) {
        self.edgeInsets = insets;
    }
    return self;
}

- (id)initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self) {
        self.edgeInsets = insets;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}
@end
