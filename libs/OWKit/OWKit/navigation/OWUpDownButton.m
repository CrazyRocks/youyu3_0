//
//  UpDownButton.m
//  PublicLibrary
//
//  Created by grenlight on 14-3-6.
//  Copyright (c) 2014年 grenlight. All rights reserved.
//

#import "OWUpDownButton.h"
#import "OWSubNavigationBar.h"
#import "OWColor.h"

@implementation OWUpDownButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [OWColor colorWithHexString:@"#22262b"];
    bgView = [[UIImageView alloc] initWithFrame:self.bounds];
    //bgView.image = bgImg;
    [self addSubview:bgView];
    
    iconView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 10, 8, 10)];
    iconView.image = [UIImage imageNamed:@"sub_navigation_more"];
    CGPoint center = bgView.center;
    center.x +=1;
    center.y += 1;
    //iconView.center = center;
    [self addSubview:iconView];
}

- (void)setExpand:(BOOL)isExpand
{
    CGAffineTransform transform;
    float alpha ;
    if (isExpand) {
        transform = CGAffineTransformRotate(CGAffineTransformIdentity,3.14);
        alpha = 0;
    }
    else {
        transform = CGAffineTransformIdentity;
        alpha = 1;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        iconView.transform = transform;
        bgView.alpha = alpha;
    }];
}

@end
