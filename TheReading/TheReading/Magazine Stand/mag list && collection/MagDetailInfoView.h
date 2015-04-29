//
//  MagDetailInfoView.h
//  TheReading
//
//  Created by mac on 15/4/22.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagDetailInfoView : UIView

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *newsDate;

@property (nonatomic, strong) LYMagazineTableCellData *magazineInfo;

@end
