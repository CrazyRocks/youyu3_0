//
//  LYPersonPageIconView.m
//  TheReading
//
//  Created by mac on 15/4/25.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import "LYPersonPageIconView.h"


#define kImgWidth       25
#define kImgHeight      30
#define kLabelWidth     45
#define kLabelHeight    20
@implementation LYPersonPageIconView {
    UIImageView *imageView;
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
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width - kImgWidth) / 2, 20, kImgWidth, kImgHeight)];
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((width - kLabelWidth) / 2, 65, kLabelWidth, kLabelHeight)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:imageView];
        [self addSubview:titleLabel];
        UITapGestureRecognizer *tapBtn = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIntoPage)];
        tapBtn.numberOfTapsRequired = 1;
        tapBtn.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapBtn];
    }
    return self;
}

- (void)setImgName:(NSString *)imgName {
    if (imgName) {
        imageView.image = [UIImage imageNamed:imgName];
    }
}

- (void)setTitleName:(NSString *)titleName {
    if (titleName) {
        titleLabel.text = titleName;
    }
}

- (void)tapIntoPage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapBtnIntoPageByIndex:)]) {
        [self.delegate tapBtnIntoPageByIndex:self.pageIndex];
    }
}
@end
