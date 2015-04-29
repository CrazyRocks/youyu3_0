//
//  LYMagzineDetailViewController.h
//  TheReading
//
//  Created by mac on 15/4/21.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYMagzineDetailViewController : UIViewController {
    LYMagazineInfoManager *magInfoManager;
}

@property (strong, nonatomic) LYMagazineTableCellData *info;

@end
