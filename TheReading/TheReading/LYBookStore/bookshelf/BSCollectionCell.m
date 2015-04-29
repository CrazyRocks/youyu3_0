//
//  MyBookItemView.m
//  KWFStore
//
//  Created by  iMac001 on 12-9-11.
//  Copyright (c) 2012年 kiwifish. All rights reserved.
//

#import "BSCollectionCell.h"
#import "MyBook.h"
#import "LYBookShelfController.h"
#import "DownloadingProgressView.h"
#import "BSCoreDataDelegate.h"
#import <OWKit/OWKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation BSCollectionCell {
    UIView *grayBack;
    UIImageView *checkIcon;
}
@synthesize myBook;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
    grayBack = [[UIView alloc]initWithFrame:CGRectMake(coverView.frame.origin.x, coverView.frame.origin.y, coverView.frame.size.width, coverView.frame.size.height + 40)];
    grayBack.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    [self addSubview:grayBack];
    
    checkIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    checkIcon.center = coverView.center;
    checkIcon.image = [UIImage imageNamed:@"magazine_down_select_false"];
    [self addSubview:checkIcon];
    checkIcon.hidden = YES;
    grayBack.hidden = YES;
    self.isEditAttention = false;
    self.isEditShelf = false;
    self.isCheckedForShelf = false;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted)
        [self setAlpha:0.6];
    else
        [self setAlpha:1];
}

-(void)setup
{
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    self.needBorrow = NO;
    sourceLB.alpha = 0;
    //splitLine.alpha = 0;
    
    self.titleHomeRect = bookNameLB.frame;
    
    shakeView.delegate = self;
    
    coverView.backgroundColor = [UIColor clearColor];
    coverView.layer.cornerRadius = 0;
    coverView.layer.borderWidth = 0.5;
    coverView.layer.borderColor = [OWColor colorWithHex:0xaaaaaa].CGColor;
    coverView.contentMode = UIViewContentModeScaleToFill;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(download_begin:) name:BOOK_DOWNLOAD_BEGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(download_progress:) name:BOOK_DOWNLOAD_PROGRESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(download_complete:) name:BOOK_DOWNLOAD_COMPLETE object:nil];
    
    bookNameLB = [[OWLabel alloc]initWithFrame:CGRectMake(coverView.frame.origin.x, coverView.frame.origin.y + coverView.frame.size.height, self.frame.size.width - 10, 40) withInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}

- (void)dealloc
{
    self.master = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(MyBook *)myBook
{
    return _myBook;
}

-(void)setMyBook:(MyBook *)amyBook
{
    _myBook = amyBook;
    [self render];
    
    if (progressView) {
        [progressView removeFromSuperview];
        progressView = nil;
        [progressMaskView removeFromSuperview];
        progressMaskView = nil;
    }
    bookNameLB = [[OWLabel alloc]initWithFrame:CGRectMake(coverView.frame.origin.x, coverView.frame.origin.y + coverView.frame.size.height, self.frame.size.width - 10, 40) withInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    bookNameLB.text = _myBook.bookName;
    bookNameLB.font = [UIFont systemFontOfSize:10];
    bookNameLB.textColor = [UIColor whiteColor];
    bookNameLB.numberOfLines = 2;
    bookNameLB.backgroundColor = [OWColor colorWithHexString:@"#08455D"];
    bookNameLB.tag = 500;
    [shakeView addSubview:bookNameLB];
    //bookNameLB.text = _myBook.bookName;
    sourceLB.text = [NSString stringWithFormat:@"来自：%@",  _myBook.unitName];
    
    labelImageView.hidden = YES;
    
    if (![_myBook.isDownloaded boolValue]) {
        labelImageView.hidden = NO;
        labelImageView.image = [UIImage imageNamed:@"未下载"];
    }
}

- (void)showRecentlyRead
{
    labelImageView.hidden = NO;
    labelImageView.image = [UIImage imageNamed:@"最近阅读"];
}

- (void)cancleRecentlyRead
{
    labelImageView.hidden = YES;
}


- (void)render
{
    if ([_myBook.smallCover componentsSeparatedByString:@"://"].count > 1) {
        [coverView setImageWithURL:_myBook.smallCover];
        return;
    }
    UIImage *image = [UIImage imageWithContentsOfFile:_myBook.smallCover];
    [coverView setImage:image];
}

-(CGRect)getCoverFrame
{
    return coverView.frame;
}

- (UIImage *)getCover
{
    return [OWImage CompositeImage:coverView];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
}

- (void)bookDownloadingBegin
{
    
}

- (void)bookDownloadingProgress:(float)grogress
{
    
}

- (void)bookDownloaded
{
    _myBook.isDownloaded = [NSNumber numberWithBool:YES];
}


#pragma mark share view delegate
- (void)shakeView_longPressed
{
    [self.master beginEdit];
}

- (void)shakeView:(OWShakeView *)shakeView delete:(UIButton *)bt
{
    if (self.master)
        [self.master deleteSelectedItem:self];
}

- (void)startShake
{
    [shakeView startShake];
}

- (void)stopShake
{
    [shakeView stopShake];
}

#pragma mark download notification

- (void)download_begin:(NSNotification *)noti
{
    NSString *bookName = ((MyBook *)[noti.userInfo objectForKey:@"bookInfo"]).bookName;
    if(![bookName isEqualToString:_myBook.bookName]) return;
    
    [self loadProgressView];
}

- (void)loadProgressView
{
    //正在下载时，不再显示未来下载标识
    labelImageView.hidden = YES;
    
    if (!progressView) {
        progressMaskView  = [[UIView alloc] initWithFrame:coverView.frame];
        progressMaskView.backgroundColor = [OWColor colorWithHexString:@"#33000000"];
        
        progressView = [[DownloadingProgressView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        progressView.center = coverView.center;
    }
    [shakeView addSubview:progressMaskView];
    [shakeView addSubview:progressView];
}

- (void)download_progress:(NSNotification *)noti
{
    NSString *bookName = ((MyBook *)[noti.userInfo objectForKey:@"bookInfo"]).bookName;
    if(![bookName isEqualToString:_myBook.bookName]) return;
    
    float progress = [[noti.userInfo objectForKey:@"progress"] floatValue];
    [self loadProgressView];
    progressView.progress = progress;
}

- (void)download_complete:(NSNotification *)noti
{
    NSString *bookName = ((MyBook *)[noti.userInfo objectForKey:@"bookInfo"]).bookName;
    if(![bookName isEqualToString:_myBook.bookName]) return;
    
    BSCoreDataDelegate *cdd = [BSCoreDataDelegate sharedInstance];
    [cdd.parentMOC performBlockAndWait:^{
        _myBook.isDownloaded = @YES;
        [cdd.parentMOC save:nil];
    }];
    
    [progressView removeFromSuperview];
    progressView = nil;
    
    [progressMaskView removeFromSuperview];
    progressMaskView = nil;
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

