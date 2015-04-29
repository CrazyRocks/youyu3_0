//
//  LYMagazineShelfController.m
//  LYMagazinesStand
//
//  Created by grenlight on 14-5-19.
//  Copyright (c) 2014年 OOWWWW. All rights reserved.
//

#import "LYMagazineShelfController.h"
#import "LYFocusedMagCollectionController.h"

@interface LYMagazineShelfController ()

@end

@implementation LYMagazineShelfController


- (BOOL)ifNeedsDrop_DownRefresh
{
    return NO;
}

- (BOOL)ifNeedsLoadingMore
{
    return NO;
}

- (NSString *)loadingMessage
{
    return @"正在加载您已下载的杂志";
}

- (NSString *)errorMessage
{
    return @"还没有您下载的杂志";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadLocalData];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    //NSLog(@"\r\n frame:%f-%f", _collectionView.frame.origin.x, _collectionView.frame.origin.y);
    /*refreshView.backgroundColor = [UIColor blackColor];
    _collectionView.backgroundColor = [UIColor clearColor];
    CGPoint oriCenter = _collectionView.center;*/
    //_collectionView.center = CGPointMake(oriCenter.x, oriCenter.y - 20);
    [self performSelector:@selector(setBtnState:) withObject:@"magazine_attention_delete" afterDelay:0.5f];
}
- (void)autoRefresh {
    
}

- (void)loadLocalData
{
    
    //[self createStatusManageView];
    
    self.isLocalMagazine = YES;
    
    pageCount = 1;
    pageIndex = 1;
   
    NSArray *list = [[LYMagazineShelfManager sharedInstance] getAllMagazines];
    //NSLog(@"\r\n listcountshelf:%lu", list.count);
    if (list && list.count > 0) {
        [statusManageView stopRequest];
        dataSource = [NSMutableArray arrayWithArray:list];
    }
    else {
        dataSource = nil;
        [statusManageView requestFault];
    }
    [self reloadDataForSelected];
    
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender {
    //[_collectionView reloadData];
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [sender locationInView:_collectionView];
        for (UICollectionViewCell *cell in _collectionView.visibleCells) {
            //NSLog(@"\r\n x:%f,y:%f,width:%f,height:%f;", cell.frame.origin.x, cell.frame.origin.y, 90.0f, 160.0f);
            editMode = true;
            MagCVCell *cellSelf = (MagCVCell *)cell;
            [cellSelf setIsEditShelf:true];
            if (CGRectContainsPoint(cell.frame, point)) {
                //[self startShake];
            }
        }
    }

}

- (void)collectionView:(UICollectionView *)theCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"\r\n mode:%d,index:%ld", editMode, indexPath.row);
    if (editMode == false) {
        [super collectionView:theCollectionView didSelectItemAtIndexPath:indexPath];
    } else {
        MagCVCell *cell = (MagCVCell *)[theCollectionView cellForItemAtIndexPath:indexPath];
        BOOL bSelected = [self getIsSelectedByIndex:indexPath.row];
        if (bSelected == true) {
            [cell setIsCheckedForShelf:false];
            
        } else {
            [cell setIsCheckedForShelf:true];
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
            LYMagazineTableCellData *info = dataSource[indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                __unsafe_unretained LYMagazineShelfController *weakSelf = self;
                [[LYMagazineShelfManager sharedInstance] deleteMagazine:info];
                [weakSelf->dataSource removeObjectAtIndex:indexPath.row];
                [weakSelf->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
                
            });
        }
    }
    [self reloadDataForSelected];
}

#pragma mark delete items
- (void)shakeView:(OWShakeableCVCell *)shakeView delete:(UIButton *)bt
{
    NSIndexPath *indexPath = [_collectionView indexPathForCell:shakeView];
    LYMagazineTableCellData *info = dataSource[indexPath.row];
    __unsafe_unretained LYMagazineShelfController *weakSelf = self;
    [[LYMagazineShelfManager sharedInstance] deleteMagazine:info];
    [_collectionView performBatchUpdates:^{
         [weakSelf->dataSource removeObjectAtIndex:indexPath.row];
         [weakSelf->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        if (weakSelf->dataSource.count >0) {
            [weakSelf startShake];
        }
        else {
            [weakSelf stopShake];
        }
    }];
}
@end
