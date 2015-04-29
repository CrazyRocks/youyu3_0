//
//  ArticleDetailController.m
//  GoodSui
//
//  Created by 龙源 on 13-7-25.
//  Copyright (c) 2013年 grenlight. All rights reserved.
//

#import "ArticleDetailController.h"
#import "FullScreenWebViewController.h"
#import "ArticleHeaderViewController.h"

@interface ArticleDetailController ()
{
    //ArticleHeaderViewController *headerController;
    LYArticleManager        *requestManager;
}
@property WebViewJavascriptBridge* bridge;

@end

@implementation ArticleDetailController

- (id)init
{
    self = [super initWithNibName:@"ArticleDetailController" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    requestManager = [[LYArticleManager alloc] init];

   // headerController = [[ArticleHeaderViewController alloc] init];
    //[self addChildViewController:headerController];
}

- (void)releaseData
{
    [statusManageView stopRequest];
    [webView loadHTMLString:@"" baseURL:nil];
    [webView stopLoading];
    
    webView.delegate = Nil;
    webView.scrollView.delegate = Nil;
    [webView removeFromSuperview];
    webView = nil;
    
    _bridge = nil;
    
    [requestManager cancelRequest];
    requestManager = nil;
    
    [super releaseData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [OWColor colorWithHexString:@"F6F5EF"];
    
    webView.delegate = self;
    webView.backgroundColor = self.view.backgroundColor;
    webView.scrollView.backgroundColor = webView.backgroundColor;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.scrollView = webView.scrollView;
    
    //去掉webView的shadow
    for (int x = 0; x < ([webView.scrollView subviews].count - 1); ++x) {
        [[webView.scrollView subviews][x] setHidden:YES];
    }
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        
    }];
    
    [_bridge registerHandler:@"fullScreen" handler:^(id data, WVJBResponseCallback responseCallback) {
        [[FullScreenWebViewController sharedInstance] showImage:data];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    //[CommonNetworkingManager sharedInstance].currentMagazine = nil;
}

- (NSString *)loadingMessage
{
    return @"正在加载文章";
}

- (NSString *)errorMessage
{
    if ([CommonNetworkingManager sharedInstance].isReachable) {
        return @"加载失败，点击此处可重新加载";
    }
    else {
        return HTTPREQEUST_NONE_NETWORK;
    }
}

- (void)setPagePosition:(CGRect)rect
{
    [self.view setFrame:rect];
    [webView.scrollView setContentOffset:CGPointZero];
}

- (void)setArticle:(LYArticleTableCellData *)article
{
    if (article && [article.titleID isEqualToString:currentArticle.titleID]) {
        return;
    }
    currentState = glArticleDetailTitleState;
    /*[webView loadHTMLString:@"<html><body style='background-color:#F6F5EF'></body></html>" baseURL:Nil];
    CGRect frame = headerController.view.frame;
    frame.size.width = CGRectGetWidth(self.view.frame);
    headerController.view.frame = frame;
    [webView.scrollView addSubview:headerController.view];
    
    [headerController setContentInfo:article];*/
}

-(void)loadArticle
{
    if(currentState == glArticleDetailCompleteState)
        return;
    
    [self createStatusManageView];
    //收藏状态变更
    [[NSNotificationCenter defaultCenter] postNotificationName:CURRENTARTICLE_CHANGED object:nil];
    
    __weak typeof (self) weakSelf = self;
    GLParamBlock faultBlock = ^(NSString *message) {
        [weakSelf requestFault:message];
    };
    
    GLParamBlock  successBlock = ^(LYArticle *art) {
        [weakSelf renderArticle:art];
    };
    [requestManager getArticleDetail:successBlock fault:faultBlock ];
}

- (void)renderArticle:(LYArticle *)art
{
    NSString *dateStr = [NSString stringWithFormat:@"%@年第%@期", art.magYear, art.magIssue];
   // NSLog(@"\r\n date:%@,author:%@,name:%@,%@,%@", dateStr, art.author, art.summary, art.subTitle, art.magName);
    [statusManageView stopRequest];

    self.contentOffset = CGPointZero;

    currentState = glArticleDetailCompleteState;
    articleDetail = art;
    [self renderByFontSize];
}

- (void)requestFault:(NSString *)msg
{
    [statusManageView requestFault];
}

- (void)renderByFontSize
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float fontSize = [defaults floatForKey:APP_FONTSIZE];
    if (fontSize < 10) {
        fontSize = appFontsize_normal;
        [defaults setFloat:fontSize forKey:APP_FONTSIZE];
        [defaults synchronize];
    }
//    articleDetail.summary = @"aaaaa xxxx xxxx xxx xxxxxxx xxxxaaaaa xxxx xxxx xxx xxxxxxx xxxxaaaaa xxxx xxxx xxx xxxxxxx xxxx";
    NSMutableString *blockquote = [NSMutableString stringWithString:@""];
    NSString *summary = articleDetail.summary;
    if (summary) {
        summary = [LYUtilityManager stringByTrimmingAllSpaces:summary];
    }
    /*
     客户要求：没有摘要也要显示那两条线、
     */
    if (!summary) {
        summary = @"";
    }
    float quoteSize = fontSize-4;
    /*[blockquote appendString:@"<hr style=\"margint-top:20px; border:1px #a0a6b0 solid;\
     -webkit-transform:scale(1,0.5);\"/>"];
    [blockquote appendFormat:@"<blockquote style='margin:10px 0px 10px 0px;padding:0px;\
     font-color:#9096a0;font-size:%fpx;line-height:%fpx\
     border-bottom:1px #ff0000 solid;transform: scaleY(0.5);'>",quoteSize,quoteSize*1.5];
    [blockquote appendString:summary];
    [blockquote appendString:@"</blockquote>"];
    [blockquote appendString:@"<hr style=\"border:1px #a0a6b0 solid; -webkit-transform:scale(1,0.5)\"/>"];*/
    //NSLog(@"\r\n name:%@,year:%d", [CommonNetworkingManager sharedInstance].currentMagazine.magName, [CommonNetworkingManager sharedInstance].fromList);
    
    NSMutableString *headerDiv = [NSMutableString stringWithFormat:@"<div id=\"headDiv\" style=\"float: right;display: block;padding: -2px 0px 0px 0px;margin-bottom: 30px\">"];

    LYArticleTableCellData * cellData = [[CommonNetworkingManager sharedInstance] getCurrentArticle];

    //NSLog(@"\r\n name:%@-%@,year:%@/%@,type:%d,id:%@,name:%@,time:%@", [CommonNetworkingManager sharedInstance].currentMagazine.magName, cellData.magName, cellData.magYear, cellData.magIssue, [CommonNetworkingManager sharedInstance].fromList, [CommonNetworkingManager sharedInstance].recommendCategoryID, [CommonNetworkingManager sharedInstance].recommendCategoryName, articleDetail.magFormattedIssue);
    switch ([CommonNetworkingManager sharedInstance].fromList) {
        case glMagazineList: {
            [headerDiv appendFormat:@"<p class=\"titleClass\">%@</p> \
             <hr style=\"border:1px dotted #D3D3D3;margin-bottom: 0px;\" /> ", [CommonNetworkingManager sharedInstance].currentMagazine.magName];
            NSString *dateStr = [NSString stringWithFormat:@"%@年第%@期", [CommonNetworkingManager sharedInstance].currentMagazine.year, [CommonNetworkingManager sharedInstance].currentMagazine.issue];
            [headerDiv appendFormat:@"<p class=\"titleClass\">%@</p> \
             <hr style=\"border:1px dotted #D3D3D3;margin-bottom: 0px;\" /> ", dateStr];
            
            break;
        }
        default: {
            break;
        }
    }
    /*if (articleDetail.magName && ![articleDetail.magName isEqualToString:@""]
         && articleDetail.magName != nil) {
        [headerDiv appendFormat:@"<p class=\"titleClass\">%@</p> \
         <hr style=\"border:1px dotted #D3D3D3;margin-bottom: 0px;\" /> ", articleDetail.magName];
        NSString *dateStr = [NSString stringWithFormat:@"%@年第%@期", [CommonNetworkingManager sharedInstance].currentMagazine.year, [CommonNetworkingManager sharedInstance].currentMagazine.issue];
        [headerDiv appendFormat:@"<p class=\"titleClass\">%@</p> \
         <hr style=\"border:1px dotted #D3D3D3;margin-bottom: 0px;\" /> ", dateStr];
    } else if ([CommonNetworkingManager sharedInstance].currentMagazine.magName && ![[CommonNetworkingManager sharedInstance].currentMagazine.magName isEqualToString:@""]) {
        [headerDiv appendFormat:@"<p class=\"titleClass\">%@</p> \
         <hr style=\"border:1px dotted #D3D3D3;margin-bottom: 0px;\" /> ", [CommonNetworkingManager sharedInstance].currentMagazine.magName];
        NSString *dateStr = [NSString stringWithFormat:@"%@年第%@期", [CommonNetworkingManager sharedInstance].currentMagazine.year, [CommonNetworkingManager sharedInstance].currentMagazine.issue];
        [headerDiv appendFormat:@"<p class=\"titleClass\">%@</p> \
         <hr style=\"border:1px dotted #D3D3D3;margin-bottom: 0px;\" /> ", dateStr];
    }*/
    /*if (articleDetail.magYear && articleDetail.magIssue && articleDetail.magYear != 0) {
        NSString *dateStr = [NSString stringWithFormat:@"%@年第%@期", articleDetail.magYear, articleDetail.magIssue];
        [headerDiv appendFormat:@"<p class=\"titleClass\">%@</p> \
         <hr style=\"border:1px dotted #D3D3D3;margin-bottom: 0px;\" /> ", dateStr];
    }*/
    if (articleDetail.author && ![articleDetail.author isEqualToString:@""]) {
        [headerDiv appendFormat:@"<p class=\"titleClass\">%@</p> \
         <hr style=\"border:1px dotted #D3D3D3;margin-bottom: 0px;\" /> ", articleDetail.author];
    }
    [headerDiv appendFormat:@"</div>"];
    [headerDiv appendFormat:@"<h3 style='font-size:20px;padding:0px;margin:0px;clear: both;margin-top: 10px;'>%@</h3>",articleDetail.title];
    float imgWidth = CGRectGetWidth(self.view.frame)-34;
    
    NSString *html = [NSString stringWithFormat:HTML_CONTENT,imgWidth, headerDiv, fontSize, fontSize*1.5, articleDetail.content];
    [webView loadHTMLString:html baseURL:Nil];
    //[headerController updateContentInfo:articleDetail];
    //[webView.scrollView addSubview:headerController.view];
   
}

- (void)fontSizeChange
{
    self.contentOffset = webView.scrollView.contentOffset;
    webView.alpha = 0;
    [self renderByFontSize];
}

- (void)reloading:(id)sender
{
    [self loadArticle];
}

- (void)clearContent
{
    [webView setAlpha:0];
}


- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    [self performSelector:@selector(limitHorizontalScroll) withObject:nil afterDelay:0];
    [UIView animateWithDuration:0.3 animations:^{
        webView.alpha = 1;
    }];
}

- (void)limitHorizontalScroll
{
    CGSize contentSize = webView.scrollView.contentSize ;
    contentSize.width  = appWidth;
    [webView.scrollView setContentSize:contentSize];
    [webView.scrollView setContentOffset:self.contentOffset];
}

-(NSString *)getArticleWebURL
{
    NSMutableString *message = [[NSMutableString alloc] init];
    [message appendString:@"#龙源阅读# "];
    
    if(articleDetail){
        [message appendString:articleDetail.title];
        [message appendString:@""];
        [message appendString: articleDetail.webURL];
    }
    else{
        [message appendString: @"http://m.qikan.com"];
    }
    return message;
}


@end
