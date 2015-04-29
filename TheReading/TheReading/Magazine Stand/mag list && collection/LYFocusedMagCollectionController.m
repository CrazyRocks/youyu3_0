//
//  LYFocusedMagCollectionController.m
//  LYMagazinesStand
//
//  Created by grenlight on 13-12-26.
//  Copyright (c) 2013年 OOWWWW. All rights reserved.
//

#import "LYFocusedMagCollectionController.h"
#import "LYMagazinesStandController.h"
#import "MagCVCell.h"
#import <OWKit/OWKit.h>
#import <LYService/LYService.h> 
#import "MagIssuesColllectionController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LYMagReaderViewController.h"
#import "LYMagazineGlobal.h"

@interface LYFocusedMagCollectionController ()
{

}
@end

@implementation LYFocusedMagCollectionController

- (id)init
{
    self = [super initWithNibName:@"MagazineCollectionController" bundle:nil];
    if (self) {
        needShowNavigationBar = YES;
        [self setup];
    }
    return self;
}

- (id)initWithNoneNavigationBar
{
    self = [super initWithNibName:@"MagazineCollectionController" bundle:nil ];
    if(self) {
        needShowNavigationBar = NO;
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isEditMode = NO;
    
    if (!longPressGestureRecognizer) {
        longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(handleLongPressGesture:)];
    }
    [self.view addGestureRecognizer:longPressGestureRecognizer];
    if (!needShowNavigationBar) {
        [navBar removeFromSuperview];
        navBar = Nil;
        
        [_collectionView setFrame:self.view.bounds];
        //[self.view addSubview:_collectionView];
    }
    else {
        [navBar setTitle:@"杂志关注"];
    }
    if (!delListBtn) {
        delListBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 30, 36, 11, 12)];
        
        [delListBtn addTarget:self action:@selector(delList) forControlEvents:UIControlEventTouchUpInside];
        [delListBtn setTag:10];
        [self.parentViewController.view addSubview:delListBtn];
    }

    editMode = false;
    isSelectDic = [[NSMutableDictionary alloc]init];
    isSelectDicIndexPath = [[NSMutableDictionary alloc]init];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"\r\n func:%s", __func__);
    [[self.parentViewController.view viewWithTag:10]setHidden:YES];
    //delListBtn.hidden = YES;
    //[delListBtn removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    [self performSelector:@selector(setBtnState:) withObject:@"magazine_attention_delete" afterDelay:0.5f];
}

- (void)setBtnState: (NSString *)imgName {
    [delListBtn setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    //delListBtn.hidden = NO;
    [self.parentViewController.view setHidden:NO];
}
- (void)refreshFun {
    [self loadLocalData];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self autoRefresh];
    
    //[self.navigationController.view addSubview:delListBtn];
        //NSLog(@"\r\n attention frame:%f-%f", _collectionView.frame.origin.x, _collectionView.frame.origin.y);
}

- (BOOL)ifNeedsDrop_DownRefresh
{
    return YES;
}

- (NSString *)loadingMessage
{
    return @"正在获取关注列表";
}

- (NSString *)errorMessage
{
    if (![CommonNetworkingManager sharedInstance].isReachable) {
        return HTTPREQEUST_NONE_NETWORK;
    }
    else {
        return @"还没有您关注的期刊";
    }
}


- (void)loadLocalData
{
    pageCount = 1;
    pageIndex = 1;

    NSArray *list = [requestManager getLocalFocusedMagazineList];
    //NSLog(@"\r\n listcountfocus:%lu", list.count);
    if (list && list.count > 0) {
        dataSource = [NSMutableArray arrayWithArray:list];
        [self reloadDataForSelected];
    }

}

- (BOOL)getIsSelectedByIndex: (NSInteger)index {
    NSNumber *returnVal = [isSelectDic objectForKey:[NSNumber numberWithInteger:index]];
    return [returnVal boolValue];
}

- (void)setIsSelectedByIndex: (NSInteger)index value: (BOOL)bVal {
    [isSelectDic setObject:[NSNumber numberWithBool:bVal] forKey:[NSNumber numberWithInteger:index]];
}

- (void)setIndexPathByIndex: (NSInteger)index value: (NSIndexPath *)indexPath {
    [isSelectDicIndexPath setObject:indexPath forKey:[NSNumber numberWithInteger:index]];
}

- (NSIndexPath *)getIndexPathByIndex: (NSInteger)index {
    return [isSelectDicIndexPath objectForKey:[NSNumber numberWithInteger:index]];
}

- (void)excuteRequest
{
    if(![[CommonNetworkingManager sharedInstance] isReachable]) {
        [self updateRequestState];
        return;
    }

    httpRequest =  [requestManager getFocusedMagazineList:pageIndex
                                          successCallBack:self.requestComplete
                                           failedCallBack:self.reqestFault];

}


- (void)addedCellIfNeedsShake:(OWShakeableCVCell *)cell
{
    if (isEditMode)
        [cell startShake];
    else
        [cell stopShake];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    MagCVCell *cell1 = (MagCVCell *)cell;
    LYMagazineTableCellData *info = dataSource[indexPath.row];
    NSString *url = [MagIssuesColllectionController getImgURL:info];
    [cell1.webImageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        ;
    }];
    
    CALayer *layer = [cell1.webImageView layer];
    layer.borderColor = [[UIColor clearColor]CGColor];
    layer.borderWidth = 0.0f;
    [cell1 setIsEditShelf:false];
    [self setIndexPathByIndex:indexPath.row value:indexPath];
    [self setIsSelectedByIndex:indexPath.row value:false];
    //NSLog(@"\r\n row:%ld,isedit:%d", indexPath.row, cell1.isEditShelf);
    return cell;
}

- (void)collectionView:(UICollectionView *)theCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (editMode == false) {
        LYMagazineTableCellData *info = dataSource[indexPath.row];

        MagIssuesColllectionController *issuesController = [[MagIssuesColllectionController alloc] initWithMagCell:info];
        NSLog(@"\r\n index:%ld", indexPath.row);
        
        if (self.isLocalMagazine || self.isMagazineIssue) {
            [[CommonNetworkingManager sharedInstance] setCurrentMagazine:info];
            [CommonNetworkingManager sharedInstance].articleIndex = 0;
            
            MagCVCell *cell = (id)[theCollectionView cellForItemAtIndexPath:indexPath];
            
            CGRect frame = [cell getCoverFrame];
            frame = [[UIApplication sharedApplication].keyWindow convertRect:frame fromView:cell];
            NSLog(@"\r\n frame,x:%f,y:%f", frame.origin.x, frame.origin.y);
            [LYMagazineGlobal sharedInstance].isLocalMagazine = self.isLocalMagazine;
            LYMagReaderViewController *controller = [[LYMagReaderViewController alloc] init];
            [self popoverPresentationController];
            
            [[OWNavigationController sharedInstance] pushViewController:controller animated:NO];
            [controller openFromRect:frame cover:[cell getCover]];
        }
        else {
            MagIssuesColllectionController *issuesController = [[MagIssuesColllectionController alloc] initWithMagCell:info];
            [self popoverPresentationController];
            [self.navigationController pushViewController:issuesController animated:YES];
        }
        
    } else {
         MagCVCell *cell = (MagCVCell *)[theCollectionView cellForItemAtIndexPath:indexPath];
         CALayer *layer = [cell.webImageView layer];
         BOOL bSelected = [self getIsSelectedByIndex:indexPath.row];
         if (bSelected == true) {
         layer.borderColor = [[UIColor clearColor]CGColor];
         layer.borderWidth = 0.0f;
         
         } else {
         layer.borderColor = [[UIColor redColor]CGColor];
         layer.borderWidth = 5.0f;
         }
         bSelected = !bSelected;
         [self setIsSelectedByIndex:indexPath.row value:bSelected];
    }
}

- (void)delList {
    NSArray *listKeys = [NSArray arrayWithArray:[isSelectDic allKeys]];
    NSArray *sortArray = [listKeys sortedArrayUsingSelector:@selector(compare:)];
    
    //NSLog(@"\r\n listkeys:%@", sortArray);
    for (NSNumber *key in [sortArray reverseObjectEnumerator]) {
        NSNumber *val = [isSelectDic objectForKey:key];
        if ([val boolValue] == true) {
            NSInteger index = [key integerValue];
            //NSLog(@"\r\n index:%ld", index);
            NSIndexPath *indexPath = [self getIndexPathByIndex:index];
            LYMagazineTableCellData *info = dataSource[index];
            [[OWMessageView sharedInstance]
             showMessage:[NSString stringWithFormat:@"正在取消对《%@》的关注",info.magName]
             autoClose:NO];
            __unsafe_unretained LYFocusedMagCollectionController *weakSelf = self;
            [((LYMagazineManager *)requestManager)
             disfocusMagazine:info
             completion:^{
                 [[OWMessageView sharedInstance]
                  showMessage:[NSString stringWithFormat:@"已取消对《%@》的关注",info.magName]
                  autoClose:YES];
                // NSLog(@"\r\n 1index:%ld",index);
                 [weakSelf->dataSource removeObjectAtIndex:index];
                 [weakSelf->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
                 
                 /*[weakSelf->_collectionView
                  performBatchUpdates:^{
                      [weakSelf->dataSource removeObjectAtIndex:index];
                      [weakSelf->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
                  }
                  completion:^(BOOL finished) {
                      if (finished)
                          //[weakSelf startShake];
                          ;
                  }];*/
                 
             } fault:^{
                 [[OWMessageView sharedInstance] showMessage:@"操作失败" autoClose:YES];
             }];

        }
    }
    [self reloadDataForSelected];
}

- (void)resetCellState: (UICollectionView *)collView{
    for (UICollectionViewCell *cell in collView.visibleCells) {
        MagCVCell *cellSelf = (MagCVCell *)cell;
        
        CALayer *layer = [cellSelf.webImageView layer];
        layer.borderColor = [[UIColor clearColor]CGColor];
        layer.borderWidth = 0.0f;
        [cellSelf setIsEditShelf:false];
    }
}

- (void)reloadDataForSelected {
    [isSelectDicIndexPath removeAllObjects];
    [isSelectDic removeAllObjects];
    
   // NSLog(@"\r\n datacount:%ld", dataSource.count);
    for (NSInteger i = 0; i < [dataSource count]; i++) {
        [self setIsSelectedByIndex:i value:false];
    }
    [_collectionView reloadData];
    editMode = false;
}

#pragma mark gesture action
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender
{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [sender locationInView:_collectionView];
        for (UICollectionViewCell *cell in _collectionView.visibleCells) {
            if (CGRectContainsPoint(cell.frame, point)) {
                editMode = true;
                //[self startShake];
                MagCVCell *cell1 = (MagCVCell *)cell;
                
                CALayer *layer = [cell1.webImageView layer];
                NSInteger index = [_collectionView indexPathForCell:cell].row;
                BOOL bSelected = [self getIsSelectedByIndex:index];
                if (bSelected == true) {
                    layer.borderColor = [[UIColor clearColor]CGColor];
                    layer.borderWidth = 0.0f;
                    
                } else {
                    layer.borderColor = [[UIColor redColor]CGColor];
                    layer.borderWidth = 5.0f;
                }
                bSelected = !bSelected;
                [self setIsSelectedByIndex:index value:bSelected];
            }
        }
    }
}

#pragma mark delete items
- (void)shakeView:(OWShakeableCVCell *)shakeView delete:(UIButton *)bt
{
    NSIndexPath *indexPath = [_collectionView indexPathForCell:shakeView];
    LYMagazineTableCellData *info = dataSource[indexPath.row];
    [[OWMessageView sharedInstance]
     showMessage:[NSString stringWithFormat:@"正在取消对《%@》的关注",info.magName]
     autoClose:NO];
    __unsafe_unretained LYFocusedMagCollectionController *weakSelf = self;
    [((LYMagazineManager *)requestManager)
     disfocusMagazine:info
     completion:^{
         [[OWMessageView sharedInstance]
          showMessage:[NSString stringWithFormat:@"已取消对《%@》的关注",info.magName]
          autoClose:YES];
         [weakSelf->_collectionView
          performBatchUpdates:^{
              [weakSelf->dataSource removeObjectAtIndex:indexPath.row];
              [weakSelf->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
          }
          completion:^(BOOL finished) {
              if (finished)
                  [weakSelf startShake];
          }];
        
     } fault:^{
         [[OWMessageView sharedInstance] showMessage:@"操作失败" autoClose:YES];
     }];
}

#pragma mark shake
- (void)startShake
{
    isEditMode = YES;

    for (OWShakeableCVCell *cell in _collectionView.visibleCells) {
        cell.owDelegate = self;
        [cell startShake];
    }
}

- (void)stopShake
{
    for (OWShakeableCVCell *cell in _collectionView.visibleCells) {
        [cell stopShake];
    }
    isEditMode = NO;
}

- (void)outEditMode
{
    [self stopShake];
}
@end
