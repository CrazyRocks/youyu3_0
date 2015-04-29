//
//  MagIssuesColllectionController.m
//  TheReading
//
//  Created by grenlight on 15/1/8.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import "MagIssuesColllectionController.h"
#import "LYMagazineGlobal.h"
#import "LYMagReaderViewController.h"
#import "MagCatalogueTableViewCell.h"
#import "MagDetailInfoView.h"
#import "LYMagazineShelfController.h"

#define kBtnHeight      45.0f

@interface MagIssuesColllectionController () {
    LYFlowNavControl *flowView;
    UITableView *tableViewCtl;
    UIButton *readBtn;
    NSMutableArray *urlDataList;
    NSMutableDictionary *allData;
    NSMutableArray *allDataArray;
    NSMutableArray *allTitleArray;
    NSMutableArray *sectionLists;
    UIButton *attentionBtn;
    UIButton *infoBtn;
    LYMagazineInfo *magInfoCurrent;
}

@end

@implementation MagIssuesColllectionController

- (id)initWithMagCell:(LYMagazineTableCellData *)info
{
    self = [super initWithNibName:@"MagIssuesColllectionController" bundle:nil];
    if (self) {
        [self setup];
        
        magInfoManager = [[LYMagazineInfoManager alloc] init];
        magInfoManager.magazineInfo = info;
        self.isMagazineIssue = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(download_maga_complete) name:DOWN_MAGA_COMPLETE object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isLocalMagazine = NO;
    _collectionView.alpha = 0;
    [self autoRefresh];
    [_collectionView removeFromSuperview];
    //[self createHeader];
}

- (void)createTableView {
    tableViewCtl = [[UITableView alloc]initWithFrame:CGRectMake(0, 264, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - flowView.frame.size.height - flowView.frame.origin.y)];
    tableViewCtl.delegate = self;
    tableViewCtl.dataSource = self;
    tableViewCtl.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewCtl.backgroundColor = [UIColor colorWithRed:250 / 255.0f green:250 / 255.0f blue:250 / 255.0f alpha:1.0f];
    [self.view addSubview:tableViewCtl];
    [tableViewCtl reloadData];
    UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 263, [UIScreen mainScreen].bounds.size.width, 6)];
    arrowView.backgroundColor = [flowView backgroundColor];
    arrowView.image = [UIImage imageNamed:@"magazine_detail_selected"];
    [self.view addSubview:arrowView];
    [self createOtherElements];
}

- (void)createOtherElements {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.downLoadBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight - kBtnHeight, screenWidth / 2, kBtnHeight)];
    self.downLoadBtn.backgroundColor = [UIColor colorWithRed:12 / 255.0f  green:88 / 255.0f blue:111 / 255.0f alpha:1.0f];
    self.downLoadBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.downLoadBtn.titleLabel.textColor = [UIColor whiteColor];
    
    readBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.downLoadBtn.frame.size.width, screenHeight - kBtnHeight, screenWidth / 2, kBtnHeight)];
    readBtn.backgroundColor = [UIColor colorWithRed:99 / 255.0f  green:183 / 255.0f blue:228 / 255.0f alpha:1.0f];
    readBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    readBtn.titleLabel.textColor = [UIColor whiteColor];
    [self.downLoadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [self.downLoadBtn addTarget:self action:@selector(downloadMagazineInfo:) forControlEvents:UIControlEventTouchUpInside];
    [readBtn addTarget:self action:@selector(readMag) forControlEvents:UIControlEventTouchUpInside];
    [readBtn setTitle:@"阅读" forState:UIControlStateNormal];
    [self.view addSubview:self.downLoadBtn];
    [self.view addSubview:readBtn];
    
    UITapGestureRecognizer *infoGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayMagInfo:)];

    attentionBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth - 35, 36, 15, 12)];
    [attentionBtn setBackgroundImage:[UIImage imageNamed:@"magazine_attention_true"] forState:UIControlStateNormal];
    [attentionBtn addTarget:self action:@selector(attentionMag:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:attentionBtn];
    
    infoBtn = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth - 80, 36, 12, 12)];
    [infoBtn setBackgroundImage:[UIImage imageNamed:@"magazine_detail_info"] forState:UIControlStateNormal];
    [infoBtn addGestureRecognizer:infoGesture];
    [self.view addSubview:infoBtn];
    [self checkFocused];
    
    
    //[infoImg addGestureRecognizer:infoGesture];
    //[self.view addSubview:infoImg];

}

- (void)createHeader {
    self.navigationItem.title = @"tetset";
    
    flowView = [[LYFlowNavControl alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, kScrollHeight)];
    flowView.backgroundColor = [UIColor whiteColor];
    flowView.delegate = self;
    [self.view addSubview:flowView];
    /*UIImageView *backBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 10, 10)];
    backBtn.image = [UIImage imageNamed:@"back_button_navigation"];
    UITapGestureRecognizer *tapReg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comeback:)];
    [backBtn addGestureRecognizer:tapReg];
    [self.view addSubview:backBtn];*/
    [self createTableView];
}

- (void)registerHeaderNib
{
    UINib *headerNib = [UINib nibWithNibName:@"IssueCollectionViewHeader"
                                      bundle:nil];
    [_collectionView registerNib:headerNib
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:@"HeaderFooter"];

}

- (void)configCollectionViewHeader:(IssueCollectionViewHeader *)headerView
{
    /*collectionHeaderView = headerView;
    [collectionHeaderView setMagInfo:magInfoManager.magazineInfo];
    NSLog(@"\r\n headerView:%f", headerView.frame.size.height);
    collectionHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);*/
}

- (BOOL)ifNeedsDrop_DownRefresh
{
    return NO;
}

- (BOOL)ifNeedsLoadingMore
{
    return YES;
}

- (void)excuteRequest
{
    __unsafe_unretained typeof (self) weakSelf = self;
    [magInfoManager getIssueList:pageIndex completion:^(NSArray *list) {
        [weakSelf loadList:list];
    } fault:^(NSString *msg) {
        [weakSelf->statusManageView requestFault];
    }];
}

- (void)loadList:(NSArray *)list
{
    
    //[collectionHeaderView setMagInfo:magInfoManager.magazineInfo];
    //UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    //[layout setHeaderReferenceSize:CGSizeMake(appWidth, CGRectGetHeight(collectionHeaderView.frame))];
    
    self.requestComplete(list, (int)magInfoManager.yearList.count);
    //collectionHeaderView.dataArray = [NSMutableArray arrayWithArray:list];
    urlDataList = [NSMutableArray arrayWithArray:list];
    [self setImgList:list];
    if ([list count] != 0) {
        [self updateDataListByIndex:0];
    }
    //NSLog(@"\r\n list:%d", (int)list.count);
    [UIView animateWithDuration:0.3 animations:^{
        _collectionView.alpha = 1;
    }];
}

+ (NSString *)getImgURL: (LYMagazineTableCellData *)info{
    NSString *coverURL ;
    NSArray *coverArr = [info.cover componentsSeparatedByString:@","];
    if (coverArr) {
        if (coverArr.count > 1 )
            coverURL = coverArr[1];
        else
            coverURL = coverArr[0];
    }
    return coverURL;
}

- (void)setImgList: (NSArray *)dataArray {
    [self createHeader];
    if (dataArray) {
        NSMutableArray *urlArray = [[NSMutableArray alloc]init];
        NSMutableArray *titleArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < [dataArray count]; i++) {
            LYMagazineTableCellData *dicData = [dataArray objectAtIndex:i];
            NSString *url = [MagIssuesColllectionController getImgURL:dicData];
            [urlArray addObject:url];
            NSString *imgTitle = [NSString stringWithFormat:@"%@年 第%@期",dicData.year, dicData.issue];
            [titleArray addObject:imgTitle];
        }
        flowView.titleList = titleArray;
        flowView.dataList = urlArray;
    }
}

- (void)updateDataListByIndex:(NSInteger)index {
    if (index < [urlDataList count]) {
        LYMagazineTableCellData *dicData = [urlDataList objectAtIndex:index];
        
        [[CommonNetworkingManager sharedInstance] setCurrentMagazine:dicData];
        [CommonNetworkingManager sharedInstance].articleIndex = 0;
        
        [LYMagazineGlobal sharedInstance].isLocalMagazine = self.isLocalMagazine;
        magInfoManager.magazineInfo = dicData;
        ;
        NSLog(@"\r\n name:%@,year:%@-%@-%@", [CommonNetworkingManager sharedInstance].currentMagazine.magName, [CommonNetworkingManager sharedInstance].currentMagazine.year, [CommonNetworkingManager sharedInstance].currentMagazine.issue, dicData.summary);
        [self checkFocused];
        [self updateDownloadBtn:magInfoCurrent];
        [self requestRemoteData];
    }
    
}

- (void)requestRemoteData
{
    isLocalData = NO;
    __weak MagIssuesColllectionController *weakSelf = self;
    void(^magCatCompletion)(NSArray *,LYMagazineInfo *) = ^(NSArray *result, LYMagazineInfo *magInfo) {
        if (result && result.count > 0) {
            [weakSelf groupDataToSection:result magInfo:magInfo];
            [tableViewCtl reloadData];
        }
    };
    [requestManager getMagazineCatelogue:magCatCompletion
                                   fault:weakSelf.reqestFault];
}

-(void)groupDataToSection:(NSArray *)arr magInfo:(LYMagazineInfo *)magInfo
{
    //NSLog(@"\r\n arrcount:%lu", arr.count);
    /*NSMutableArray *sections = [[NSMutableArray alloc] init];
    NSString *currentSectionName ;
    NSMutableArray *sectionData;*/
    magInfoCurrent = magInfo;
    [self updateDownloadBtn:magInfo];
    allDataArray = [NSMutableArray arrayWithArray:arr];
    allData = [[NSMutableDictionary alloc]init];
    allTitleArray = [[NSMutableArray alloc]init];
    for (LYMagCatelogueTableCellData *cell in arr) {
        [allTitleArray addObject:cell.title];
        if (cell.sectionName) {
            id sectionListForIndex = [allData objectForKey:cell.sectionName];
            if (sectionListForIndex == nil || ![sectionListForIndex isKindOfClass:[NSMutableArray class]]) {
                sectionListForIndex = [[NSMutableArray alloc]init];
                [sectionListForIndex addObject:cell];
                [allData setObject:sectionListForIndex forKey:cell.sectionName];
            } else {
                [sectionListForIndex addObject:cell];
            }
        } else {
            id sectionListForIndex = [allData objectForKey:@"其它"];
            if (sectionListForIndex == nil || ![sectionListForIndex isKindOfClass:[NSMutableArray class]]) {
                sectionListForIndex = [[NSMutableArray alloc]init];
                [sectionListForIndex addObject:cell];
                [allData setObject:sectionListForIndex forKey:@"其它"];
            } else {
                [sectionListForIndex addObject:cell];
            }
        }
        
        /*NSLog(@"\r\n cell:%@", cell.title);
        if (!currentSectionName ||
            (![cell.sectionName isEqualToString:currentSectionName] &&
             cell.sectionName)) {
                currentSectionName = cell.sectionName;
                if (!currentSectionName) {
                    currentSectionName = @"其它";
                }
                sectionData = [[NSMutableArray alloc] init];
                [sectionData addObject:cell];
                [sections addObject:sectionData ];
                [sectionNameList addObject:[currentSectionName copy]];
            }
        else {
            [sectionData addObject:cell];
        }*/
    }
    sectionLists = [[NSMutableArray alloc]initWithArray:[allData allKeys]];
}

- (void)displayMagInfo: (id)sender {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    MagDetailInfoView *detailView = [[MagDetailInfoView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [detailView setMagazineInfo:magInfoManager.magazineInfo];
    
    //NSLog(@"\r\n cur:%@,%@", [CommonNetworkingManager sharedInstance].currentMagazine.magName, [CommonNetworkingManager sharedInstance].currentMagazine.catName);
   // NSLog(@"\r\n cur:%@,%@", magInfoManager.magazineInfo.magName, magInfoManager.magazineInfo.catName);
    [self.view addSubview:detailView];
}

- (void)attentionMag: (id)sender {
    if (bAttention) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"杂志关注" message:@"该杂志已经关注" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    } else {
        [LYMagazineManager attentionMagazine:magInfoManager.magazineInfo bySender:sender];
    }
}

- (void)checkFocused
{
    LYMagazineTableCellData *curData = [CommonNetworkingManager sharedInstance].currentMagazine;
    if (!curData || (requestedMagGUID && [requestedMagGUID isEqualToString:curData.magGUID])) {
        return;
    }
    requestedMagGUID = magInfoManager.magazineInfo.magGUID;
    [LYMagazineManager isFocused:requestedMagGUID completion:^{
        bAttention = YES;
        [attentionBtn setBackgroundImage:[UIImage imageNamed:@"magazine_attention_true"] forState:UIControlStateNormal];
    } fault:^{
        bAttention = NO;
        [attentionBtn setBackgroundImage:[UIImage imageNamed:@"magazine_attention_false"] forState:UIControlStateNormal];
    }];
}

- (void)updateDownloadBtn: (LYMagazineInfo *)info {
    
    BOOL isDownloaded = [[LYMagazineShelfManager sharedInstance] isDownloaded:info];
    if (isDownloaded) {
        [self.downLoadBtn setTitle:@"已下载" forState:UIControlStateNormal];
        [self.downLoadBtn setSelected:NO];
    }
    else {
        [self.downLoadBtn setTitle:@"下载" forState:UIControlStateNormal];
        [self.downLoadBtn setSelected:NO];
    }

}

- (void)readMag {
    [CommonNetworkingManager sharedInstance].articles = allDataArray;
    [CommonNetworkingManager sharedInstance].articleIndex = 0;
    //NSLog(@"\r\n articleIndex:%ld,indexPath:%ld-%ld", articleIndex, indexPath.section, indexPath.row);
    
    [LYMagazineGlobal sharedInstance].isLocalMagazine = self.isLocalMagazine;
    LYMagReaderViewController *controller = [[LYMagReaderViewController alloc] init];
    [[OWNavigationController sharedInstance] pushViewController:controller animated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MAG_OPEN_CONTENT object:nil];
}

- (void)downloadMagazineInfo:(UIButton *)btn
{
    BOOL isDownloaded = [[LYMagazineShelfManager sharedInstance] isDownloaded:magInfoCurrent];
    if (isDownloaded) {
        return;
    }
    
    [[LYMagazineShelfManager sharedInstance] downloadMagazine:magInfoCurrent];
    [btn setTitle:@"下载中..." forState:UIControlStateNormal];
    [btn setSelected:YES];
    //[addToShelfBT setSelected:YES];
}

- (void)download_maga_complete {
    [self.downLoadBtn setTitle:@"已下载" forState:UIControlStateNormal];
    [self.downLoadBtn setSelected:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionLists count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionLists objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tableViewCtl.frame.size.width, 1)];
    [imgView setBackgroundColor:[UIColor redColor]];
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    footView.backgroundColor = [UIColor colorWithRed:0 green:51 / 255.0f blue:82 / 255.0f alpha:1.0f];
    [footView addSubview:imgView];
    return footView;
}

- (UIView *)tableView:(UITableView *)tableV viewForHeaderInSection:(NSInteger)section {
    NSString *titleStr = [self tableView:tableV titleForHeaderInSection:section];
    UILabel *sectionHeader = [[UILabel alloc]initWithFrame:CGRectMake(8, 7, 100, 25)];
    sectionHeader.text = titleStr;
    sectionHeader.backgroundColor = [UIColor clearColor];
    sectionHeader.font = [UIFont systemFontOfSize:13];
    sectionHeader.textColor = [UIColor colorWithRed:0 green:51 / 255.0f blue:82 / 255.0f alpha:1.0f];
    UIView *secView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableV.frame.size.width, 25)];
    
    if (section != 0) {
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableV.frame.size.width, 0.5)];
        footView.backgroundColor = [UIColor colorWithRed:0 green:51 / 255.0f blue:82 / 255.0f alpha:0.6f];
        [secView addSubview:footView];
    }
    
    [secView addSubview:sectionHeader];
    return secView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionName = [sectionLists objectAtIndex:section];
    NSMutableArray *sectionList = [allData objectForKey:sectionName];
    return [sectionList count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"MagCell";
    MagCatalogueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[MagCatalogueTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString *sectionTitle = [sectionLists objectAtIndex:indexPath.section];
    
    NSMutableArray *catalogueArray = [allData objectForKey:sectionTitle];
    LYMagCatelogueTableCellData *cellData = [catalogueArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [tableViewCtl backgroundColor];
    cell.titleLabel.text = cellData.title;
    //NSLog(@"\r\n section:%@,title:%@", sectionTitle, cellData.title);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger articleIndex = 0;
    
    NSString *secName = sectionLists[indexPath.section];
    NSArray *items = [allData objectForKey:secName];
    LYMagCatelogueTableCellData *cellData = [items objectAtIndex:indexPath.row];
    NSString *titleName = cellData.title;
    NSInteger index = [allTitleArray indexOfObject:titleName];
    articleIndex = index;
    /*for (uint i = 0; i < indexPath.section; i++) {
        NSString *secName = sectionLists[i];
        NSArray *items = [allData objectForKey:secName];
        articleIndex += items.count;
    }
    articleIndex += indexPath.row;*/
    
    [CommonNetworkingManager sharedInstance].articles = allDataArray;
    [CommonNetworkingManager sharedInstance].articleIndex = articleIndex;
    [CommonNetworkingManager sharedInstance].fromList = glMagazineList;
    //NSLog(@"\r\n articleIndex:%ld,indexPath:%ld-%ld", articleIndex, indexPath.section, indexPath.row);
    
    [LYMagazineGlobal sharedInstance].isLocalMagazine = self.isLocalMagazine;
    LYMagReaderViewController *controller = [[LYMagReaderViewController alloc] init];
    [[OWNavigationController sharedInstance] pushViewController:controller animated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MAG_OPEN_CONTENT object:nil];
    
    
}

- (void)comeback:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!CGRectContainsPoint(flowView.frame, point)) {
        return flowView;
    }
    return self.view;
    //return [super hitTest:point withEvent:event];
}

@end
