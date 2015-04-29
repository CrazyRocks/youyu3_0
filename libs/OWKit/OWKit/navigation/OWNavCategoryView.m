//
//  OWNavCategoryView.m
//  OWKit
//
//  Created by mac on 15/4/24.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import "OWNavCategoryView.h"
#import "OWPublicLib.h"
#import "OWSubNavigationBar.h"
#import <OWColor.h>

#define kMarginX        1
#define kMarginY        1
#define kHeightArrow    30
@implementation OWNavCategoryView {
    UIView *headView;
    UILabel *titleLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {        
        headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
        headView.backgroundColor = [OWColor colorWithHexString:@"#2B3036"];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, CGRectGetWidth(self.bounds)-80, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
        UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 30, 40, 11, 12)];
       
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"ow_close_view.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        
        [headView addSubview:closeBtn];
        [headView addSubview:titleLabel];
        [self addSubview:headView];
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
        
    }
    return self;
}

- (void)closeView {
    [self tapButton:nil];
}

- (void)setTitleStr:(NSString *)titleStr {
    if (titleStr) {
        titleLabel.text = titleStr;
    }
}

- (void)setCategoryList:(NSMutableArray *)categoryList {
    //NSLog(@"\r\n count:%ld", [categoryList count]);
    if (categoryList && categoryList.count != 0) {
        //NSLog(@"\r\n count:%ld", [categoryList count]);
        
        CGFloat height = 40.0f;
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - kMarginX) / 2;
        
        UIImage *normalBackground = [UIImage imageNamed:@"BgOnlist.png"];
        UIImage *selectBackground = [UIImage imageNamed:@"BgSelectedOnlist.png"];
        CGFloat offSetX = 0;
        CGFloat offSetY = 0;
        for (NSInteger i = 0; i < categoryList.count; i++) {

            //NSLog(@"\r\n i:%ld,offSetX:%f,offSetY:%f", i, offSetX, offSetY);
            if (i % 2 == 0) {
                offSetX = 0;
            } else {
                offSetX = width + kMarginX;
            }
            
            offSetY = headView.frame.size.height + (height + kMarginY) * floor(i / 2);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            [button setFrame:CGRectMake(offSetX, offSetY, width, height)];
            [self addSubview:button];
            OWSubNavigationItem *cat = categoryList[i];
            //NSLog(@"\r\n i:%ld,name:%@,offSetX:%f,offSetY:%f", i, cat.catName, offSetX, offSetY);
            [button setBackgroundImage:normalBackground forState:UIControlStateNormal];
            [button setBackgroundImage:selectBackground forState:UIControlStateHighlighted];
            [button setBackgroundImage:selectBackground forState:UIControlStateSelected];
            
            [button setTitle:cat.catName forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];

        }
        CGFloat x = self.frame.origin.x;
        CGFloat y = self.frame.origin.y;
        CGFloat w = self.frame.size.width;
        self.frame = CGRectMake(x, y, w, offSetY + height);
    }
}

- (void)tapButton:(UIButton *)sender
{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(returnNavControlByButton:)]) {
        [self.delegate returnNavControlByButton:sender];
    }
}

@end
