//
//  OWSubNavigationController.m
//  PublicLibrary
//
//  Created by grenlight on 14-5-6.
//  Copyright (c) 2014年 grenlight. All rights reserved.
//

#import "OWSubNavigationController.h"
#import "PathStyleGestureController.h"
#import "OWUpDownButton.h"
#import <OWColor.h>
#import "OWPublicLib.h"

@interface OWSubNavigationController ()
{
    OWViewController        *sortingController;
    OWNavCategoryView       *navCatView;
    UIView                  *empView;
}
@end

@implementation OWSubNavigationController

@synthesize currentListController;

- (id)init
{
    self = [super initWithNibName:@"OWSubNavigationController" bundle:[NSBundle bundleForClass:[OWSubNavigationController class]]];
    if (self) {
        if ([self ifNeedsSorting]) {
            sortingController = [[[self getSortingControllerClass] alloc] init];
            [self addChildViewController:sortingController];
        }
        
        pagingController = [[OWPagingViewController alloc] init];
        [self addChildViewController:pagingController];
        
        isExpand = NO;
        sortingPanelFrame = CGRectZero;
        self.currentPageIndex = -1;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sorttingControllerItemSelected:) name:@"BCSItemSelected" object:nil];
        
    }
    return self;
}


- (void)dealloc
{
    self.navigationBar.delegate = nil;
    pagingController.pagingDelegate = Nil;
    [self releaseData];
}

- (BOOL)ifNeedsSorting
{
    return YES;
}

- (void)sorttingControllerItemSelected:(NSNotification *)note
{
    if (![self isViewLoaded] || self.view.window == nil || self.view.superview == nil) {
        return;
    }
    NSDictionary *info= note.userInfo;
    [self.navigationBar autoTapByIndex:[info[@"selectedIndex"] integerValue] ];
    [self expandCategoriesPanel:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.clipsToBounds = YES;

    pagingController.view.backgroundColor = [UIColor lightGrayColor];
    pagingController.pageCount = [self getPageCount];
    pagingController.pageDisplayed = self.currentPageIndex;
    
    [self.view insertSubview:pagingController.view atIndex:0];
    UIEdgeInsets padding = UIEdgeInsetsMake(41, 0, 0, 0);
    [pagingController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
    }];
   
    if (self.currentPageIndex == -1) {
        currentListController = [[[self getListControllerClass] alloc] init];
        
        pagingController.prePage = [[[self getListControllerClass] alloc] init];
        pagingController.currentPage = currentListController;
        pagingController.nextPage = [[[self getListControllerClass] alloc] init];
        pagingController.pagingDelegate = self;
        
        self.view.alpha = 0;
    }
    else {
        [pagingController restoreViews];
    }
    
    if (![self ifNeedsSorting]) {
        [udButton removeFromSuperview];
    }
    [self.view bringSubviewToFront:udButton];
    //[self.view addSubview:udButton];
    [self.navigationBar renderItems:[self subNavDataSource]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.currentPageIndex == -1) {
        [pagingController completeConfig];
    }
    [self performSelector:@selector(renderContent) withObject:nil afterDelay:0.1];
}

- (void)renderContent
{
    self.navigationBar.delegate = self;

    if (self.currentPageIndex > -1) {
        [self.navigationBar renderItems:[self subNavDataSource] selectedIndex:self.currentPageIndex];
    }
    else {
        [self.navigationBar renderItems:[self subNavDataSource]];
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 1;
    }];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
}

- (IBAction)expandCategoriesPanel:(id)sender
{
    empView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    empView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:empView];
    //[self.navigationController.view addSubview:empView];
    navCatView = [[OWNavCategoryView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400)];
    navCatView.categoryList = [NSMutableArray arrayWithArray:[self subNavDataSource]];
    navCatView.delegate = self;
    navCatView.alpha = 0.0f;
    navCatView.titleStr = [OWPublicLib getCurrentTitle];
    [empView addSubview:navCatView];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        navCatView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        udButton.backgroundColor = [OWColor colorWithHexString:@"#22262b"];
    }];
    //NSLog(@"\r\n title:%@", [OWPublicLib getCurrentTitle]);
    
    /*if (isExpand) {
        NSLog(@"\r\n expent");
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            //sortingController.view.center = schoolCenter;
            navCatView.alpha = 0.0f;
            //self.navigationBar.alpha = 1;
        } completion:^(BOOL finished) {
            udButton.backgroundColor = [OWColor colorWithHexString:@"#22262b"];
        }];
    } else {
        NSLog(@"\r\n no expent");
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            //sortingController.view.center = schoolCenter;
            //self.navigationBar.alpha = 0;
            navCatView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            udButton.backgroundColor = [OWColor colorWithHexString:@"#22262b"];
        }];
    }*/
    isExpand = !isExpand;
    [udButton setExpand:isExpand];
    
    /*
    if (CGRectEqualToRect(sortingPanelFrame, CGRectZero)) {
        sortingPanelFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.frame));
        homeCenter = CGPointMake(CGRectGetWidth(self.view.bounds)/2.0f, CGRectGetHeight(sortingPanelFrame)/2.0f);
        schoolCenter = homeCenter;
        schoolCenter.y -= CGRectGetHeight(sortingPanelFrame);
    }
    if (isExpand) {
        [PathStyleGestureController sharedInstance].canLeftMove = YES;
        [PathStyleGestureController sharedInstance].canRightMove = YES;
        
        self.currentPageIndex = -1;
        
        //[self.navigationBar renderItems:[self subNavDataSource]];
        /*[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            sortingController.view.center = schoolCenter;
            //self.navigationBar.alpha = 1;
            
        } completion:^(BOOL finished) {
            udButton.backgroundColor = [OWColor colorWithHexString:@"#22262b"];
        }];
    }
    else {
        [PathStyleGestureController sharedInstance].canLeftMove = NO;
        [PathStyleGestureController sharedInstance].canRightMove = NO;
        udButton.backgroundColor = [UIColor clearColor];
        [sortingController.view setFrame:sortingPanelFrame];
        sortingController.view.center = schoolCenter;
        [self.view insertSubview:sortingController.view belowSubview:self.navigationBar];
        [navCatView removeFromSuperview];
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            sortingController.view.center = homeCenter;
            self.navigationBar.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
    isExpand = !isExpand;
    [udButton setExpand:isExpand];
*/
}

- (void)returnNavControlByButton:(UIButton *)tapButton {
    if (empView) {
        [empView removeFromSuperview];
        empView = nil;
    }
    [self.navigationBar buttonTapped:tapButton];
}

- (Class)getSortingControllerClass
{
    return nil;
}

- (Class)getListControllerClass
{
    return nil;
}

- (NSInteger)getPageCount
{
    return 0;
}

- (NSArray *)subNavDataSource
{
    return nil;
}

#pragma mark subNavBar delegate
- (float)navigationBarItemWidth
{
    return 80;
}

- (UIEdgeInsets)subNavigationBarEdgeInsets
{
    float rightDistance = 0;
    if ([self ifNeedsSorting]) {
        rightDistance = 31;
    }
    return UIEdgeInsetsMake(0, 0, 0, rightDistance);
}

#
- (void)pagingView:(OWViewController *)pv preloadPage:(NSInteger)pageIndex
{
    
}

- (void)pagingView:(OWViewController *)pv loadPage:(NSInteger)pageIndex
{
    self.currentPageIndex = pageIndex;
}

@end
