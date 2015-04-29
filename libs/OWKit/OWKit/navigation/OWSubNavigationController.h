//
//  OWSubNavigationController.h
//  PublicLibrary
//
//  Created by grenlight on 14-5-6.
//  Copyright (c) 2014年 grenlight. All rights reserved.
//

#import "OWSubNavigationBar.h"
#import "OWPagingViewController.h"
#import "OWNavCategoryView.h"

@class OWUpDownButton;
@interface OWSubNavigationController : OWViewController<SubNavigationBarDelegate,UIScrollViewDelegate,OWPagingViewDelegate,OWNavCategoryView>
{
    
    __weak IBOutlet OWUpDownButton       *udButton;

    //排序面板是否为打开状态
    BOOL    isExpand;
    CGPoint homeCenter, schoolCenter;
    CGRect  sortingPanelFrame;
    
    OWSubNavigationItem   *selectedCategory;
    
    NSArray             *_subNavDataSource;
    
    OWPagingViewController  *pagingController;

}
@property (nonatomic, strong) IBOutlet OWSubNavigationBar   *navigationBar;
@property (nonatomic, strong) OWViewController *currentListController;
@property (nonatomic, assign) NSInteger         currentPageIndex;

//子导航数据
- (NSArray *)subNavDataSource;

- (Class)getListControllerClass;
- (Class)getSortingControllerClass;
- (NSInteger)getPageCount;
- (void)renderContent;
- (void)setBackgroundColor:(UIColor *)color;

- (BOOL)ifNeedsSorting;

- (IBAction)expandCategoriesPanel:(id)sender;

@end

