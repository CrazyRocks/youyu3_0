//
//  LYBarcodeResultViewController.m
//  LYBookStore
//
//  Created by grenlight on 14-3-26.
//  Copyright (c) 2014年 OOWWWW. All rights reserved.
//

#import "LYBookDetailController.h"
#import <LYService/LYService.h>
#import "LYEpubDownloadButton.h"
#import "LYBookItemData.h"

@interface LYBookDetailController ()

@end

@implementation LYBookDetailController

- (id)init
{
    self = [super initWithNibName:@"LYBookDetailController" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[navBar setTitle:@"简介"];
    
    messageBT.hidden = YES;
    
    self.view.backgroundColor = [OWColor colorWithHex:0xf9f8f8];
    webView.backgroundColor = self.view.backgroundColor;
    webView.scrollView.backgroundColor = self.view.backgroundColor;
    
    [backButton setIcon:@"back_button" inBundle:nil];
    
    //去掉webView的shadow
    for (NSInteger x = 0; x < ([webView.scrollView subviews].count - 1); ++x) {
        [[webView.scrollView subviews][x] setHidden:YES];
    }
    [downloadButton.layer setBorderWidth:1.0f];
    UIColor *downBtnFontColor = [UIColor colorWithRed:0 / 255.0f green:88 / 255.0f blue:112 / 255.0f alpha:1];
    [downloadButton.layer setBorderColor:downBtnFontColor.CGColor];
    [downloadButton.layer setCornerRadius:15.0];
    [downloadButton.layer setMasksToBounds:YES];
    UIImage *downImg = [UIImage imageNamed:@"book_button_download"];
    UIImageView *downImgView = [[UIImageView alloc]initWithFrame:CGRectMake(9, 11, 10, 9)];
    downImgView.tag = 100;
    downImgView.image = downImg;
    [downloadButton addSubview:downImgView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requestContent];
}

- (void)updateStatusBarStyle
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)requestContent
{
    messageBT.hidden = YES;

//    if (self.contentInfo) {
//        [self renderContent:self.contentInfo];
//        return;
//    }

    [self createStatusManageView];
    webView.alpha = 0;
    
    __unsafe_unretained typeof(self) weakSelf = self;

    [[MyBooksManager sharedInstance] getBookDetail:self.bookGUID successCallBack:^(NSDictionary *results) {
        [weakSelf renderContent:results];
    } failedCallBack:^(NSString *msg) {
        [weakSelf->statusManageView stopRequest];
        weakSelf->messageBT.hidden = NO;
        [weakSelf->messageBT setTitle:msg forState:UIControlStateNormal];
    }];
}

- (void)reloading:(id)sender
{
    [self requestContent];
}

- (void)renderContent:(NSDictionary *)result
{
    [statusManageView stopRequest];
    LYBookItemData *bookItem = [[LYBookItemData alloc] init];
    bookItem.name = result[@"BookName"];
    bookItem.price = @0;
    bookItem.cover = result[@"CoverImage"];
    bookItem.author = result[@"Author"];
//    bookItem.categoryName = result[@"Category"];
    bookItem.summary = result[@"Note"];
    bookItem.ISBN = result[@"ISBN"];
    bookItem.downloadUrl = result[@"epubDonwloadURL"];
    bookItem.publishName = result[@"PublishName"];
    bookItem.isBookMode = YES;
    
    NSString *headerHTML =[NSString stringWithFormat: @"<div><div style='float:left;width:100px; height:150px; '>\
    <img style='margin-top:20px; margin-left:15px; width:95px; height:140px;background-color:gray' src='%@'  /></div>\
    <div style='float:left;margin-left:25px;width:185px;height:150px; font-size:11px; color:gray;margin-top: 40px;'>\
    <p><span style='color:#005870;font-size: 13px;'>%@</p>\
    <p><span style='color:#999999;font-size: 13px;'>%@</span></p>\
    <p><span style='color:#999999;font-size: 13px;'>%@</span></p>\
    </div> \
    <hr style='width: 100%%;'/> \
    </div>",bookItem.cover, bookItem.name, bookItem.author, bookItem.publishName];
    
    NSString *summary = bookItem.summary;
    if (!summary)
        summary = @"";
    
    [webView loadHTMLString:[NSString stringWithFormat:BOOK_DETAIL_HTML,headerHTML, summary] baseURL:nil];
    [self performSelector:@selector(animateIn) withObject:nil afterDelay:0.1];
    [navBar setTitle:bookItem.name];
    [downloadButton setBookInfo:bookItem];
}

- (void)animateIn
{
    headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 150);
    [webView.scrollView addSubview:headerView];
//    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, appHeight-64-198, 0);
//    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(webView.mas_top).with.offset(padding.top);
//        make.left.equalTo(webView.mas_left).with.offset(padding.left);
//        make.right.equalTo(webView.mas_right).with.offset(-padding.right);
//        make.height.mas_equalTo(198);
//
//    }];
    [UIView animateWithDuration:0.25 animations:^{
        webView.alpha = 1;
    }];
}

- (void)comeback:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [super comeback:sender];
    }
}

@end
