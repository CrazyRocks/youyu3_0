//
//  OWPublicLib.h
//  OWKit
//
//  Created by mac on 15/4/15.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OWPublicLib : NSObject

+ (UIImage *)imageWithColor: (UIColor *)color size: (CGSize)size;

+ (UIImage *)resizeImgFromImg: (UIImage *)oriImg toSize: (CGSize)toSize;

+ (NSString *)getCurrentTitle;
+ (void)setCurrentTitle: (NSString *)curTitle;
@end
