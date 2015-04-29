//
//  MagDetailInfoView.m
//  TheReading
//
//  Created by mac on 15/4/22.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import "MagDetailInfoView.h"

#define kDetailViewMarginLeft       28
#define kDetailViewMarginTop        80
#define kMarginLeft                 15
#define kMarginRight                15
#define kFontColor      [UIColor colorWithRed:151 / 255.0f green:151 / 255.0f  blue:151 / 255.0f alpha:1.0f]
#define kFontSize       [UIFont systemFontOfSize:14]
#define kTitleLabelHeight           20
#define kTitleLabelWidth            35
#define kMarginLeftToTitle          5
#define kMarginTopToTitle           8
#define kBtnMarginRight             15
#define kBtnMarginBottom            20
#define kBtnWidth                   40
#define kBtnHeight                  20

@implementation MagDetailInfoView {
    UILabel *titleLabel;
    UILabel *categoryLabel;
    UILabel *newsDateLabel;
    UILabel *contentLabel;
    UIButton *closeBtn;
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
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        
        UIView *bcView = [[UIView alloc]initWithFrame:CGRectMake(kDetailViewMarginLeft, kDetailViewMarginTop, screenWidth - kDetailViewMarginLeft * 2, screenHeight - kDetailViewMarginTop * 2)];
        bcView.backgroundColor = [UIColor colorWithRed:250 / 255.0f green:250 / 255.0f blue:250 / 255.0f alpha:1.0f];
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMarginLeft, kMarginLeft, bcView.frame.size.width - kMarginLeft, 50)];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [bcView addSubview:titleLabel];
        
        UILabel *categoryTitle = [[UILabel alloc]initWithFrame:CGRectMake(kMarginLeft, titleLabel.frame.size.height + 20, kTitleLabelWidth, kTitleLabelHeight)];
        categoryTitle.text = @"分类:";
        categoryTitle.font = kFontSize;
        categoryTitle.textColor = kFontColor;
        
        CGFloat categoryTitleWidth = categoryTitle.frame.size.width;
        CGFloat categoryTitleHeight = categoryTitle.frame.size.height;
        CGFloat categoryTitleX = categoryTitle.frame.origin.x;
        CGFloat categoryTitleY = categoryTitle.frame.origin.y;
        
        categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(categoryTitleX + categoryTitleWidth + kMarginLeftToTitle, categoryTitleY, self.frame.size.width - (categoryTitleX + categoryTitleWidth + kMarginLeftToTitle), categoryTitleHeight)];
        categoryLabel.font = kFontSize;
        categoryLabel.textColor = kFontColor;
        
        [bcView addSubview:categoryTitle];
        [bcView addSubview:categoryLabel];
        
        UILabel *newsTitle = [[UILabel alloc]initWithFrame:CGRectMake(categoryTitleX, categoryTitleY + categoryTitleHeight + kMarginTopToTitle, categoryTitleWidth, categoryTitleHeight)];
        newsTitle.text = @"刊期:";
        newsTitle.font = kFontSize;
        newsTitle.textColor = kFontColor;
        
        newsDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(categoryLabel.frame.origin.x, newsTitle.frame.origin.y, categoryLabel.frame.size.width, categoryTitleHeight)];
        newsDateLabel.font = kFontSize;
        newsDateLabel.textColor = kFontColor;
        
        [bcView addSubview:newsTitle];
        [bcView addSubview:newsDateLabel];
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(categoryTitleX, newsTitle.frame.origin.y + newsTitle.frame.size.height + kMarginLeftToTitle, bcView.frame.size.width - kMarginLeft * 2, 200)];
        contentLabel.numberOfLines = 12;
        contentLabel.font = kFontSize;
        contentLabel.textColor = kFontColor;
        

        
        [bcView addSubview:contentLabel];
        
        closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(bcView.frame.size.width - kBtnMarginRight - kBtnWidth, bcView.frame.size.height - kBtnMarginBottom - kBtnHeight, kBtnWidth, kBtnHeight)];
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        closeBtn.titleLabel.textColor = [UIColor colorWithRed:0 green:54 / 255.0f blue:83 / 255.0f alpha:1.0f];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setTitleColor:[UIColor colorWithRed:0 green:54 / 255.0f blue:83 / 255.0f alpha:1.0f] forState:UIControlStateNormal];
        [bcView addSubview:closeBtn];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
        [bcView addGestureRecognizer:gesture];
        [backView addSubview:bcView];
        [backView addGestureRecognizer:gesture];
        [self addSubview:backView];
    }
    return self;
}

- (void)closeView {
    [self removeFromSuperview];
}

- (void)setMagazineInfo:(LYMagazineTableCellData *)magazineInfo {
    if (magazineInfo) {
        titleLabel.text = magazineInfo.magName;
        categoryLabel.text = magazineInfo.catName;
        newsDateLabel.text = [LYUtilityManager magazineCycleByType:magazineInfo.cycle];
        
        CGSize size = CGSizeZero;
        if (magazineInfo.summary) {
            size = [magazineInfo.summary sizeWithFont:[UIFont systemFontOfSize:14] width:contentLabel.frame.size.width];
        }
        
        CGRect nFrame = contentLabel.frame;
        nFrame.size.height = size.height + 10;
        contentLabel.frame = nFrame;
        contentLabel.text = magazineInfo.summary ?:@"";
    }
}

@end
