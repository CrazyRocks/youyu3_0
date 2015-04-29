//
//  OWLabel.h
//  OWKit
//
//  Created by mac on 15/4/16.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OWLabel : UILabel

@property (nonatomic) UIEdgeInsets edgeInsets;

- (id)initWithFrame:(CGRect)frame withInsets:(UIEdgeInsets)insets;
- (id)initWithInsets:(UIEdgeInsets)insets;

@end
