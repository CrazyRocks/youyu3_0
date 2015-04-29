//
//  LYMagReaderViewController.m
//  LYMagazinesStand
//
//  Created by grenlight on 14-5-19.
//  Copyright (c) 2014年 OOWWWW. All rights reserved.
//

#import "LYMagReaderViewController.h"
#import <OWCoreText/OWHTMLToAttriString.h>
#import "MagCatelogueListController.h"
#import "ArticleDetailMainController.h"
#import <OWKit/OWKit.h>
#import <LYService/LYService.h>
#import "LYMagazineGlobal.h"


@interface LYMagReaderViewController ()
{
    MagCatelogueListController *catController;
    ArticleDetailMainController   *contController;

    OWCoverAnimationView    *coverView;
    UIView                  *contentView;

}
@end

@implementation LYMagReaderViewController


- (id)init
{
    self = [super init];
    if (self) {
        catController =  [[MagCatelogueListController alloc] init];
        [self addChildViewController:catController];
        
        contController  = [[ArticleDetailMainController alloc] init];
        [self addChildViewController:contController];
        
        __weak typeof (self) weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:MAG_BACKTO_SHELF object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            [weakSelf quitReader];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:MAG_OPEN_CATALOGUE object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            [weakSelf intoCatalogue];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:MAG_OPEN_CONTENT object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            [weakSelf intoContent];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:MAG_CONTINUE_READ object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            [weakSelf continueRead];
        }];
    }
    return self;
}

- (void)releaseData
{
    [coverView removeFromSuperview];
    coverView = nil;
    
    [super releaseData];
}

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, appWidth, appHeight)];
    
    contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentView.clipsToBounds = YES;
    contentView.backgroundColor = [OWColor colorWithHexString:@"#fafafa"];
    [self.view addSubview:contentView];
    
    coverView = [[OWCoverAnimationView alloc] initWithFrame:contentView.bounds];
    coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [contentView addSubview:coverView];
    
    [self performSelector:@selector(removePanGesture) withObject:nil afterDelay:1];
    
    self.navBar = [[OWNavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(17, 37, 9, 10)];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"back_button_navigation"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(quitReader) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:self.backBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    centerFrame = leftFrame = rightFrame = self.view.bounds;
    leftFrame.origin.x = (-appWidth);
    rightFrame.origin.x = appWidth;
    
    [contController.view setFrame:rightFrame];
    [contentView addSubview:contController.view];
}

-  (void)openWithNoneCover
{
    isCoverMode = NO;
    contentView.frame = self.view.bounds;
    [self contentAlphaIn];
    coverView.hidden = YES;
}

- (void)updateStatusBarStyle
{
   
}

- (void)removePanGesture
{
    for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            [self.view removeGestureRecognizer:gesture];
            return;
        }
    }
}

- (void)openFromRect:(CGRect)rect cover:(UIImage *)img
{
    isCoverMode = YES;
    [coverView viewWithImage:img];
    
    //NSLog(@"\r\n x:%f,y:%f", self.view.bounds.origin.x, self.view.bounds.origin.y);
    homeFrame = rect;
    CGPoint point = CGPointMake(rect.origin.x, self.navBar.frame.size.height);
    //homeFrame.origin = point;
    [contentView setFrame:homeFrame];
    CGRect frame = CGRectMake(0, point.y, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView animateWithDuration:0.45 animations:^{
        contentView.frame = frame;
    }];
    [self contentAlphaIn];
    [coverView performSelector:@selector(startAnimation) withObject:nil afterDelay:0.1];
    [self.view addSubview:self.navBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navBar removeFromSuperview];
}


- (void)contentAlphaIn
{
    if (![NSThread isMainThread]) {
        [NSThread mainThread];
    }
    catController.view.alpha = 0;
    catController.view.frame = centerFrame;
    [contentView insertSubview:catController.view atIndex:0];
    [UIView animateWithDuration:0.35 animations:^{
        catController.view.alpha = 1;
    }];
}

- (void)intoCatalogue
{
    catController.view.frame = leftFrame;
    [contentView insertSubview:catController.view atIndex:1];
    
    [UIView animateWithDuration:0.25 animations:^{
        catController.view.frame = centerFrame;
        contController.view.frame = rightFrame;
    }];
    [catController updateStatusBarStyle];

}

- (void)intoContent
{
    [self.navBar removeFromSuperview];
    [contentView setFrame:self.view.bounds];
    contController.view.frame = rightFrame;
    [contentView addSubview:contController.view];
    [contController clearOldContent];
    
    [UIView animateWithDuration:0.25 animations:^{
        catController.view.frame = leftFrame;
        contController.view.frame = centerFrame;
    } completion:^(BOOL finished) {
        [catController.view removeFromSuperview];
        [contController updateStatusBarStyle];
        [contController renderContentView];
    }];
}

- (void)continueRead
{
    contController.view.frame = rightFrame;
    [contentView addSubview:contController.view];
    
    [UIView animateWithDuration:0.25 animations:^{
        catController.view.frame = leftFrame;
        contController.view.frame = centerFrame;
    } completion:^(BOOL finished) {
        [catController.view removeFromSuperview];
        [contController updateStatusBarStyle];
        [contController continueRead];
    }];
}

- (void)quitReader
{
    [self.navBar removeFromSuperview];
    __weak typeof (self) weakSelf = self;
    if (isCoverMode) {
        [contentView bringSubviewToFront:coverView];
        [coverView closeCover:^{
            [weakSelf backToHome];
        }];
        [[OWNavigationController sharedInstance] popViewControllerWithNoneAnimation:1.0];
    }
    else {
        [super comeback:nil];
    }
}

- (void)backToHome
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         contentView.frame = homeFrame;
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

@end
