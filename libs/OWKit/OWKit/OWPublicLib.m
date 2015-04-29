//
//  OWPublicLib.m
//  OWKit
//
//  Created by mac on 15/4/15.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import "OWPublicLib.h"

static NSString *g_curTitle = @"";
@implementation OWPublicLib

+ (UIImage *)imageWithColor: (UIColor *)color size: (CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctf = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctf, [color CGColor]);
    CGContextFillRect(ctf, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)resizeImgFromImg: (UIImage *)oriImg toSize: (CGSize)toSize {
    CGFloat oriWidth = oriImg.size.width;
    CGFloat oriHeight = oriImg.size.height;
    float widthScale = toSize.width * 1.0 / oriWidth;
    float heightScale = toSize.height * 1.0 / oriHeight;
    
    CGFloat scaleSize = 1;
    scaleSize = (widthScale > heightScale) ? heightScale : widthScale;
    CGSize realSize;
    realSize.width = oriWidth * scaleSize;
    realSize.height = oriHeight * scaleSize;
    UIGraphicsBeginImageContext(realSize);
    [oriImg drawInRect:CGRectMake(0, 0, realSize.width, realSize.height)];
    UIImage *returnImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"\r\n oriImg:%f-%f;returnImg:%f-%f", oriImg.size.width, oriImg.size.height, returnImg.size.width, returnImg.size.height);
    return returnImg;
}

+ (NSString *)getCurrentTitle {
    return g_curTitle;
}

+ (void)setCurrentTitle: (NSString *)curTitle {
    g_curTitle = curTitle;
}

@end
