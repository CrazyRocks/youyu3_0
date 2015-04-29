//
//  MagCVCell.m
//  PublicLibrary
//
//  Created by grenlight on 13-12-4.
//  Copyright (c) 2013年 grenlight. All rights reserved.
//

#import "MagCVCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MagCVCell {
    UIView *grayBack;
    UIImageView *checkIcon;
}

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

    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setFrame:CGRectMake(-22, -22, 64, 64)];
    [deleteButton setImage:[UIImage imageNamed:@"deleteCollectionItem_bt_normal"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setAlpha:0];
    [self addSubview:deleteButton];
    
    [self.superview.superview bringSubviewToFront:deleteButton];
    
    self.webImageView.layer.cornerRadius = 0;
    self.webImageView.layer.borderWidth = 0.5;
    self.webImageView.layer.borderColor = [OWColor colorWithHex:0xaaaaaa].CGColor;
    self.webImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    grayBack = [[UIView alloc]initWithFrame:CGRectMake(self.webImageView.frame.origin.x, self.webImageView.frame.origin.y, self.webImageView.frame.size.width, self.webImageView.frame.size.height + 40)];
    grayBack.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    [self addSubview:grayBack];
    
    checkIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    checkIcon.center = self.webImageView.center;
    checkIcon.image = [UIImage imageNamed:@"magazine_down_select_false"];
    [self addSubview:checkIcon];
    checkIcon.hidden = YES;
    grayBack.hidden = YES;
    self.isEditAttention = false;
    self.isEditShelf = false;
    self.isCheckedForShelf = false;
}


- (void)setContent:(LYMagazineTableCellData *)mag
{
    NSString *coverURL ;
    NSArray *coverArr = [mag.cover componentsSeparatedByString:@","];
    if (coverArr) {
        if (coverArr.count > 1 )
            coverURL = coverArr[1];
        else
            coverURL = coverArr[0];
    }
    /*titleLB.text = mag.magName;
    issueLB.text = [NSString stringWithFormat:@"%@年第%@期",mag.year, mag.issue];*/
    
    [self.webImageView setImageWithURL:coverURL];
    
    id oldLabel = [self viewWithTag:500];
    if ([oldLabel isKindOfClass:[OWLabel class]]) {
        [oldLabel removeFromSuperview];
    }
    id imgDown = [self viewWithTag:501];
    if ([imgDown isKindOfClass:[UIImageView class]]) {
        [imgDown removeFromSuperview];
    }
    OWLabel *owLabel = [[OWLabel alloc]initWithFrame:CGRectMake(self.webImageView.frame.origin.x, self.webImageView.frame.origin.y + self.webImageView.frame.size.height, self.frame.size.width - 10, 40) withInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    owLabel.text = mag.magName;
    owLabel.font = [UIFont systemFontOfSize:10];
    owLabel.textColor = [UIColor whiteColor];
    owLabel.numberOfLines = 2;
    owLabel.backgroundColor = [OWColor colorWithHexString:@"#08455D"];
    owLabel.tag = 500;
    
    [self addSubview:owLabel];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.alpha = 0.5;
    }
    else {
        self.alpha = 1.f;
    }
}

- (void)startShake
{
    [super startShake];
    [UIView animateWithDuration:0.2 animations:^{
        [deleteButton setAlpha:1];
    }];
}

- (void)stopShake
{
    [super stopShake];
    [UIView animateWithDuration:0.15 animations:^{
        [deleteButton setAlpha:0];
    }];
}

- (void)deleteButtonTapped:(UIButton *)sender
{
    if (self.owDelegate)
        [self.owDelegate shakeView:self delete:sender];
}

- (CGRect)getCoverFrame
{
   return  self.webImageView.frame;
}

- (UIImage *)getCover
{
    return [OWImage CompositeImage:self.webImageView];
}

- (void)setIsEditShelf:(BOOL)isEditShelf {
    if (isEditShelf == true) {
        grayBack.hidden = NO;
        checkIcon.hidden = NO;
    } else {
        grayBack.hidden = YES;
        checkIcon.hidden = YES;
    }
}
- (void)setIsCheckedForShelf:(BOOL)isCheckedForShelf {
    if (isCheckedForShelf == true) {
        checkIcon.image = [UIImage imageNamed:@"magazine_down_select_true"];
    } else {
        checkIcon.image = [UIImage imageNamed:@"magazine_down_select_false"];
    }
}

@end
