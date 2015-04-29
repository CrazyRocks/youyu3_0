//
//  OWNavCategoryView.h
//  OWKit
//
//  Created by mac on 15/4/24.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OWNavCategoryView <NSObject>

- (void)returnNavControlByButton: (UIButton *)tapButton;

@end

@interface  OWNavCategoryView: UIView

@property (strong, nonatomic) NSMutableArray *categoryList;
@property (strong, nonatomic) NSString *titleStr;
@property (nonatomic) BOOL isExpend;

@property (nonatomic, assign) id<OWNavCategoryView> delegate;

@end
