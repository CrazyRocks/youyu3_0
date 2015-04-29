//
//  OfflineViewController.m
//  PublicLibrary
//
//  Created by grenlight on 14-5-29.
//  Copyright (c) 2014年 grenlight. All rights reserved.
//

#import "OfflineViewController.h"
#import "LYBookStore.h"
#import "LYMagazinesStand.h"
#import "LYMagazineShelfController.h"

@interface OfflineViewController ()
{
    LYBookShelfController *bookShelf;
    LYMagazineShelfController *magShelf;
    LYFocusedMagCollectionController *focusedMagCollectionController;
    
    OWViewController    *currentController;
}
@end

@implementation OfflineViewController

- (id)init
{
    self = [super init];
    if (self) {
        bookShelf = [[LYBookShelfController alloc] initWithNoneNavigationBar];
        bookShelf.bookType = lyBook;
        [self addChildViewController:bookShelf];
        
        magShelf = [[LYMagazineShelfController alloc] init];
        magShelf.isLocalMagazine = YES;
        
        [self addChildViewController:magShelf];
        
        focusedMagCollectionController = [[LYFocusedMagCollectionController alloc] initWithNoneNavigationBar];
        [self addChildViewController:focusedMagCollectionController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    segmentControl.hidden = YES;
    self.view.backgroundColor = [OWColor colorWithHexString:@"#fafafa"];
    //[self intoViewController:magShelf];

    UIStyleObject *style = [[UIStyleManager sharedInstance] getStyle:@"书架模块顶部SegmentedControl"];
    [segmentControl setStyle:style];
}

- (void)viewDidDisappear:(BOOL)animated {
    [delListBtn removeFromSuperview];
    //delListBtn.hidden = YES;
}

- (void)segmentedValueChanged:(KWFSegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        [self intoViewController:magShelf];
    }
    else {
        [self intoViewController:bookShelf];
    }
}

- (void)intoViewController:(OWViewController *)controller
{
    controller.view.alpha = 1;
    [self.view insertSubview:controller.view atIndex:0];
    UIEdgeInsets padding = UIEdgeInsetsMake(64, 0, 0, 0);
    [controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
    }];
    
    if (currentController != controller) {
        [UIView animateWithDuration:0.3 animations:^{
            currentController.view.alpha = 0;
        } completion:^(BOOL finished) {
            [currentController.view removeFromSuperview];
            currentController = controller;
        }];
    }

}

- (void)comeback:(id)sender
{
    if (self.returnToPreController) {
        self.returnToPreController();
    }
    else
        [super comeback:sender];
}

- (void)setPageIndex:(NSInteger)pageIndex {
    if (pageIndex == PAGE_INTO_BOOK_DOWNLOAD) {
        navBar.titleLB.text = @"图书下载";
        [self intoViewController:bookShelf];
    } else if (pageIndex == PAGE_INTO_MAGAZINE_DOWNLOAD){
        navBar.titleLB.text = @"杂志下载";
        [self intoViewController:magShelf];
    } else {
        navBar.titleLB.text = @"杂志关注";
        [self intoViewController:focusedMagCollectionController];
    }
    _pageIndex = pageIndex;
}

@end
