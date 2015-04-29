//
//  LYPersonPageIconView.h
//  TheReading
//
//  Created by mac on 15/4/25.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYPersonPageIconView <NSObject>

- (void)tapBtnIntoPageByIndex: (NSInteger)index;

@end

@interface LYPersonPageIconView : UIView

@property (strong, nonatomic) NSString *imgName;
@property (strong, nonatomic) NSString *titleName;
@property (nonatomic) NSInteger pageIndex;

@property (nonatomic, assign) id<LYPersonPageIconView> delegate;

@end
