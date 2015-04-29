//
//  LYFocusedMagCollectionController.h
//  LYMagazinesStand
//
//  Created by grenlight on 13-12-26.
//  Copyright (c) 2013年 OOWWWW. All rights reserved.
//

#import "MagazineCollectionController.h"
#import "MagCVCell.h"

@interface LYFocusedMagCollectionController : MagazineCollectionController<OWShakeableCVCellDelegate>
{
    UIGestureRecognizer *longPressGestureRecognizer;
    NSMutableDictionary *isSelectDic;
    NSMutableDictionary *isSelectDicIndexPath;
    BOOL editMode;
    
}
@property (nonatomic, copy) ReturnMethod returnToPreController;
@property (nonatomic, copy) UIButton *delBtn;
- (void)startShake;
- (void)stopShake;
- (id)initWithNoneNavigationBar;
- (BOOL)getIsSelectedByIndex: (NSInteger)index;

- (void)setIsSelectedByIndex: (NSInteger)index value: (BOOL)bVal;

- (void)setIndexPathByIndex: (NSInteger)index value: (NSIndexPath *)indexPath ;
- (void)delList;
- (void)reloadDataForSelected;
- (NSIndexPath *)getIndexPathByIndex: (NSInteger)index;
- (void)resetCellState: (UICollectionView *)collView;
- (void)refreshFun;
@end
