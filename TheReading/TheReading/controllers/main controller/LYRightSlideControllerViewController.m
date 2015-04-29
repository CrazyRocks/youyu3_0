//
//  LYRightSlideControllerViewController.m
//  TheReading
//
//  Created by grenlight on 12/6/14.
//  Copyright (c) 2014 grenlight. All rights reserved.
//

#import "LYRightSlideControllerViewController.h"
#import "MainMenuCell.h"
#import "SettingViewController.h"
#import "WYContentCanvasController.h"
#import <SDWebImage/UIImageView+WebCache.h> 
#import <LYService/LYAccountManager.h> 
#import "WYRootController_iPad.h"

#define kPaddingX       2
#define kPaddingY       2
#define kMarginLeft     62

typedef enum {
    PAGE_MAGAZINE_DOWNLOAD,
    PAGE_BOOK_DOWNLOAD,
    PAGE_MAGAZINE_ATTENTION,
    PAGE_FAVOURITE
}page_selected_person;

@interface LYRightSlideControllerViewController ()

@end

@implementation LYRightSlideControllerViewController

- (void)awakeFromNib
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (isPad) {
        bgLeftConstraint.constant = appWidth-255;
        self.view.backgroundColor = [UIColor clearColor];
        contentView.backgroundColor = [OWColor colorWithHexString:@"#292C33"];
    }
    else {
        self.view.backgroundColor = [UIColor grayColor];
        contentView.backgroundColor = [OWColor colorWithHexString:@"#292C33"];
    }
    headerView.backgroundColor = [UIColor clearColor];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:LOGIN_SUCCESSED object:nil];
    [self createView];
    [self updateUI];
}

- (void)updateUI
{
    if (![self isViewLoaded]) {
        return;
    }
    [headerBgImageView sd_setImageWithURL:[NSURL URLWithString:[LYAccountManager getValueByKey:ACCOUNT_HEADER_BG]]];
    [logoImageView sd_setImageWithURL:[NSURL URLWithString:[LYAccountManager getValueByKey:LOGO_URL]]];
    unitNameLB.text = [LYAccountManager getValueByKey:UNIT_NAME];
    /*displayNameLB.text = [LYAccountManager getValueByKey:DISPLAY_NAME];
    cellPhoneLB.text = [LYAccountManager getValueByKey:CELL_PHONE];*/
}

- (void)createView {
    CGFloat width = headerView.frame.size.width;
    CGFloat height = contentView.frame.size.height;
    CGFloat oriX = contentView.frame.origin.x + kMarginLeft;
    CGFloat oriY = contentView.frame.origin.y;
    CGFloat imgWidth = (width - kPaddingX) / 2;
    CGFloat imgHeight = 90;
    UIColor *colorImg = [OWColor colorWithHexString:@"#32383F"];
    
    //NSLog(@"\r\n x:%f,y:%f,width:%f,height:%f", oriX, oriY, width, height);
    headerView.frame = CGRectMake(oriX, oriY, width, 170);
    [contentView addSubview:headerView];
    
    LYPersonPageIconView *downMag = [[LYPersonPageIconView alloc]initWithFrame:CGRectMake(oriX, headerView.frame.size.height + oriY, imgWidth, imgHeight)];
    [downMag setImgName:@"personal_magazine_download"];
    [downMag setTitleName:@"杂志下载"];
    [downMag setPageIndex:PAGE_MAGAZINE_DOWNLOAD];
    [downMag setDelegate:self];
    [downMag setBackgroundColor:colorImg];
    
    LYPersonPageIconView *downBook = [[LYPersonPageIconView alloc]initWithFrame:CGRectMake(oriX + imgWidth + kPaddingX, headerView.frame.size.height + oriY, imgWidth, imgHeight)];
    [downBook setImgName:@"personal_book_download"];
    [downBook setTitleName:@"图书下载"];
    [downBook setPageIndex:PAGE_BOOK_DOWNLOAD];
    [downBook setDelegate:self];
    [downBook setBackgroundColor:colorImg];
    
    LYPersonPageIconView *attentionMag = [[LYPersonPageIconView alloc]initWithFrame:CGRectMake(oriX, headerView.frame.size.height + oriY + imgHeight + kPaddingY, imgWidth, imgHeight)];
    [attentionMag setImgName:@"personal_magazine_attention"];
    [attentionMag setTitleName:@"杂志关注"];
    [attentionMag setPageIndex:PAGE_MAGAZINE_ATTENTION];
    [attentionMag setDelegate:self];
    [attentionMag setBackgroundColor:colorImg];
    
    LYPersonPageIconView *fav = [[LYPersonPageIconView alloc]initWithFrame:CGRectMake(oriX + imgWidth + kPaddingX, headerView.frame.size.height + oriY + imgHeight + kPaddingY, imgWidth, imgHeight)];
    [fav setImgName:@"personal_favourite"];
    [fav setTitleName:@"文章收藏"];
    [fav setPageIndex:PAGE_FAVOURITE];
    [fav setDelegate:self];
    [fav setBackgroundColor:colorImg];
    
    [contentView addSubview:downMag];
    [contentView addSubview:downBook];
    [contentView addSubview:attentionMag];
    [contentView addSubview:fav];
    
    UIButton *setBtn = [[UIButton alloc]initWithFrame:CGRectMake(width - 25, 20, 15, 15)];
    [setBtn setBackgroundImage:[UIImage imageNamed:@"personal_setting"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(configSettings) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:setBtn];
}

- (void)tapBtnIntoPageByIndex:(NSInteger)index {
    switch (index) {
        case PAGE_MAGAZINE_DOWNLOAD:
            [self.contentCanvasController intoOfflineByIndex:PAGE_INTO_MAGAZINE_DOWNLOAD];
            break;
            
        case PAGE_BOOK_DOWNLOAD:
            [self.contentCanvasController intoOfflineByIndex:PAGE_INTO_BOOK_DOWNLOAD];
            break;
            
        case PAGE_MAGAZINE_ATTENTION:
            [self.contentCanvasController intoOfflineByIndex:PAGE_INTO_ATTENTION];
            break;
        
        case PAGE_FAVOURITE:
            [self.contentCanvasController intoFavoriteList];
            break;
            
        default:
            break;
    }
}
- (void)configSettings {
    [self intoSetting:nil];
}

- (Class)cellClass
{
    return [MainMenuCell class];
}

- (void)configCell:(MainMenuCell *)cell data:(LYMenuData *)item indexPath:(NSIndexPath *)indexPath
{
    cell.needRenderForiPad = NO;
    [cell setContent:item];
}

- (void)excuteRequest
{
    [statusManageView stopRequest];

    NSArray *arr = @[@{@"MenuValue":@"favorite:", @"MenuName":@"收藏"},
                     @{@"MenuValue":@"offline:", @"MenuName":@"离线书架"},
                     @{@"MenuValue":@"setting:", @"MenuName":@"设置"}];
    NSMutableArray *list = [NSMutableArray new];
    for (NSInteger i=0; i<arr.count; i++) {
        LYMenuData *md = [MTLJSONAdapter modelOfClass:[LYMenuData class] fromJSONDictionary:arr[i] error:nil];
        [list addObject:md];
    }
    
    
    dataSource = [[OWTableViewDataSource alloc] initWithItems:list configureCellBlock:cellConfigBlock];
    _tableView.dataSource = dataSource;
    _tableView.delegate = self;
    _tableView.tableHeaderView = headerView;
    [_tableView reloadData];
}

- (void)excuteRequestNew {
    [statusManageView stopRequest];
    
}

#pragma mark table delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self.contentCanvasController intoFavoriteList];
            break;
        
        case 1:
            [self.contentCanvasController intoOffline];
            break;
            
        default:
            [self intoSetting:nil];
            break;
    }
    if (isPad) {
        WYRootController_iPad *padController = (WYRootController_iPad *)self.parentViewController;
        if (padController) {
            [padController performSelector:@selector(intoAccountView)];
        }
    }
}

- (void)intoSetting:(id)sender
{
    [self presentViewController:[[SettingViewController alloc] init] animated:YES completion:nil];
}

- (IBAction)blanckClick:(id)sender {
    if (isPad) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.view.center = CGPointMake(appWidth + 255/2.0f, appHeight/2.0f);
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
        }];
    }
}

@end
