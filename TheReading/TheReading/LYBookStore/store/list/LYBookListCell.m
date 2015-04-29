//
//  LYBookListCell.m
//  LYBookStore
//
//  Created by grenlight on 14-5-7.
//  Copyright (c) 2014年 OOWWWW. All rights reserved.
//

#import "LYBookListCell.h"
#import <OWKit/OWKit.h>
#import <LYService/LYGlobalConfig.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <OWColor.h>

@implementation LYBookListCell

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
    
    [self showBorder];
}

- (void)showBorder
{
    webImageView.backgroundColor = [UIColor clearColor];
    //webImageView.contentMode = UIViewContentModeScaleAspectFill;
    webImageView.layer.cornerRadius = 0;
    webImageView.layer.borderWidth = 0.5;
    webImageView.layer.borderColor = [OWColor colorWithHex:0xaaaaaa].CGColor;
    webImageView.clipsToBounds = YES;
    //NSLog(@"\r\n self-width:%f,height:%f", self.bounds.size.width, self.frame.size.height);
}

- (void)setContent:(NSDictionary *)info
{
    [webImageView setImageWithURL:info[@"CoverImages"]];
    /*UIFont *font = [UIFont systemFontOfSize:12];
    CGSize size = [info[@"BookName"] sizeWithFont:font width:CGRectGetWidth(bookNameLB.frame)];
    
    if (size.height > 15) {
        titleHeightConstraint.constant = 30;
    }
    else {
        titleHeightConstraint.constant = 15;
    }*/
    //bookNameLB.text = info[@"BookName"];
    id oldLabel = [self viewWithTag:500];
    if ([oldLabel isKindOfClass:[OWLabel class]]) {
        [oldLabel removeFromSuperview];
    }
    id imgDown = [self viewWithTag:501];
    if ([imgDown isKindOfClass:[UIImageView class]]) {
        [imgDown removeFromSuperview];
    }
    OWLabel *owLabel = [[OWLabel alloc]initWithFrame:CGRectMake(webImageView.frame.origin.x, webImageView.frame.origin.y + webImageView.frame.size.height, self.frame.size.width - 10, 40) withInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    owLabel.text = info[@"BookName"];
    owLabel.font = [UIFont systemFontOfSize:10];
    owLabel.textColor = [UIColor whiteColor];
    owLabel.numberOfLines = 2;
    owLabel.backgroundColor = [OWColor colorWithHexString:@"#08455D"];
    owLabel.tag = 500;
    
    LYBookItemData *bookItem = [[LYBookItemData alloc] init];
    bookItem.name = info[@"BookName"];
    downloadStatus = [[MyBooksManager sharedInstance] isDownloaded:bookItem.bGUID];
    //NSLog(@"\r\n guid:%@,name:%@,downloadStatus:%ld", bookItem.bGUID, owLabel.text, downloadStatus);
    if (downloadStatus == 1 || downloadStatus == 2) {
        UIImage *imgDownload = [UIImage imageNamed:@"book_download"];
        UIImageView *imgDownloadView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        imgDownloadView.tag = 501;
        imgDownloadView.image = imgDownload;
        [self addSubview:imgDownloadView];
    } else {
        
    }
    [self addSubview:owLabel];
}

@end
