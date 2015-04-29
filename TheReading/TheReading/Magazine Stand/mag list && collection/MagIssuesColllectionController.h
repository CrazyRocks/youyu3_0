//
//  MagIssuesColllectionController.h
//  TheReading
//
//  Created by grenlight on 15/1/8.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import "MagazineCollectionController.h"
#import "IssueCollectionViewHeader.h"
#import "LYFlowNavControl.h"

@interface MagIssuesColllectionController : MagazineCollectionController <UITableViewDataSource, UITableViewDelegate, LYFlowNavControlDelegate>
{
    LYMagazineInfoManager *magInfoManager;
    __weak IssueCollectionViewHeader *collectionHeaderView;
    LYMagazineTableCellData  *magInfo;
    NSString    *requestedMagGUID;
    BOOL        bAttention;
}
@property (strong, nonatomic) IBOutlet OWNavigationBar *magNavBar;

@property (strong, nonatomic) UIButton *downLoadBtn;

- (id)initWithMagCell:(LYMagazineTableCellData *)info;
+ (NSString *)getImgURL: (LYMagazineTableCellData *)info;
@end
