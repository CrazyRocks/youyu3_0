//
//  LYMagzineDetailViewController.m
//  TheReading
//
//  Created by mac on 15/4/21.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import "LYMagzineDetailViewController.h"
#import "LYFlowNavControl.h"

@interface LYMagzineDetailViewController () {
    LYFlowNavControl *flowView;
}


@end

@implementation LYMagzineDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createHeader];
}

- (void)setInfo:(LYMagazineTableCellData *)info {
    if (info) {
        magInfoManager = [[LYMagazineInfoManager alloc] init];
        magInfoManager.magazineInfo = self.info;
        [self excuteRequest];
    }
}

- (void)createHeader {
    flowView = [[LYFlowNavControl alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    flowView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:flowView];
    
}

- (void)excuteRequest
{
    __unsafe_unretained typeof (self) weakSelf = self;
    [magInfoManager getIssueList:2 completion:^(NSArray *list) {
        [weakSelf loadList:list];
    } fault:^(NSString *msg) {
        ;
    }];
}

- (void)loadList:(NSArray *)list
{
    NSLog(@"\r\n list:%d", (int)list.count);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
