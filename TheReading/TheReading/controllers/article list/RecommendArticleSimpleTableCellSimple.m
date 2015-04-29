//
//  RecommendArticleSimpleTableCellSimple.m
//  TheReading
//
//  Created by mac on 15/4/27.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import "RecommendArticleSimpleTableCellSimple.h"
#import <LYArticleManager.h>

@implementation RecommendArticleSimpleTableCellSimple

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIView *selectedBG = [[UIView alloc] initWithFrame:self.bounds];
        selectedBG.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = selectedBG;
        
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib
{
    if (isPad) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        self.contentLabel.font = [UIFont systemFontOfSize:16];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentLabel.frame);
}

- (void)setContent:(LYArticleTableCellData *)info
{
    /*NSLog(@"\r\n publishDateSection:%@,date:%@, info.title:%@, summary:%@", info.publishDateSection, info.publishDate,
          info.title, info.summary);*/
    self.contentView.clipsToBounds = YES;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    
    /*NSString *titleID = info.titleID;
    LYArticle *art = [[LYArticleManager sharedInstance] getLocalArticleByID:titleID];
    NSLog(@"\r\n conte:%@", art.content);*/
    self.titleLabel.text = info.title;
    self.contentLabel.text = info.summary;
    
    contentInfo = info;
}

-(void)rerenderContent
{
    [contentInfo setAlreadyRead:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
