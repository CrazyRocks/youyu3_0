//
//  LYFlowNavControl.h
//  YZTest
//
//  Created by apple on 15/4/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScrollHeight       200
typedef void(^DownloadComplete)(UIImage *) ;


@protocol LYFlowNavControlDelegate <NSObject>

@optional

- (void)updateDataListByIndex:(NSInteger)index; /*通过index更新数据列表*/

@end

@interface LYFlowNavControl : UIView <UIScrollViewDelegate>

- (id)initWithFrame:(CGRect)frame;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) NSMutableArray *titleList;
@property (nonatomic) CGSize imgSize;
@property (nonatomic, assign) id<LYFlowNavControlDelegate> delegate;

@end

