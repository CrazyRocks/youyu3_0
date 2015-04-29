//
//  LYFlowNavControl.m
//  YZTest
//
//  Created by apple on 15/4/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LYFlowNavControl.h"
#import <OWPublicLib.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LYFlowNavControl {
    NSMutableArray *listArray;
    NSMutableArray *imgArray;
    UIScrollView *scrollViewCtl;
    UILabel *titleLabel;
}

#define kCellWidth          110
#define kCellTitleWidth      120
#define kImgViewPadding     0
#define kPaddingX           80
#define kScrollWidth        200
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        listArray = self.dataList;
    }
    return self;
}

- (void)setDataList:(NSMutableArray *)dataList {
    if (dataList) {
        _dataList = dataList;
        listArray = dataList;
        if (dataList.count != self.titleList.count) {
            NSLog(@"\r\n get list error from database.");
            return;
        }
        [self initImg];
        [self initScrollView];
    }
}

- (void)initScrollView {
    scrollViewCtl = [[UIScrollView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - kScrollWidth) / 2, 0, kScrollWidth, self.bounds.size.height)];
    scrollViewCtl.delegate = self;
    scrollViewCtl.clipsToBounds = NO;
    scrollViewCtl.showsHorizontalScrollIndicator = NO;
    scrollViewCtl.showsVerticalScrollIndicator = NO;
    scrollViewCtl.autoresizesSubviews = NO;
    scrollViewCtl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollViewCtl.multipleTouchEnabled = NO;
    scrollViewCtl.decelerationRate = UIScrollViewDecelerationRateFast;
    scrollViewCtl.pagingEnabled = YES;
    //scrollViewCtl.backgroundColor = [UIColor blueColor];
    __block CGFloat x = 0;
    
    UIImageView *imgView = [imgArray firstObject];
    CGRect viewFrame = CGRectMake((kScrollWidth - kCellWidth) / 2, 15, kCellWidth, imgView.frame.size.height);
    CGRect backFrame = viewFrame;
    [imgArray enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {
        obj.frame = CGRectOffset(backFrame, x, 0);
        [scrollViewCtl addSubview:obj];
        x += kScrollWidth;
    }];
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - kCellTitleWidth) / 2, imgView.frame.size.height + 22, kCellTitleWidth, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //titleLabel.backgroundColor = [UIColor blueColor];
    if ([self.titleList count] != 0) {
        titleLabel.text = self.titleList[0];
    }
    [self addSubview:titleLabel];
    //CGFloat padding = (kScrollWidth - kCellWidth) / 2;
    
    CGFloat width = scrollViewCtl.frame.size.width * listArray.count;
    width = x;
    scrollViewCtl.contentSize = CGSizeMake(width, scrollViewCtl.frame.size.height);
    [self addSubview:scrollViewCtl];
    //NSLog(@"\r\n imglen:%lu,scrollwidth:%f", [imgArray count], scrollViewCtl.contentSize.width);
    

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (index < [self.titleList count]) {
        titleLabel.text = self.titleList[index];
        if ([self.delegate respondsToSelector:@selector(updateDataListByIndex:)]) {
            [self.delegate updateDataListByIndex:index];
        }
        //NSLog(@"\r\n scrollx:%f-%ld-%@", scrollViewCtl.contentOffset.x, index, self.titleList[index]);
    } else {
        NSLog(@"\r\n magazine list is empty or selected cell is invalid.");
    }

}
- (void)downloadImgFromUrlGCD: (NSString *)urlStr complete:(DownloadComplete)complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:urlStr];
        NSData *imgData = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:imgData];
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(img);
        });
    });
}

- (void)initImg {
    imgArray = [[NSMutableArray alloc]init];
    [listArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger index, BOOL *stop) {
        NSURL *url = [NSURL URLWithString:obj];
        //NSLog(@"\r\n url:%@", url);
        //UIImage *oriImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];

        UIImageView *v = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 150)];
        //v.image = oriImg;
        [v sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            ;
        }];
        /*[self downloadImgFromUrlGCD:obj complete:^(UIImage *img) {
            if (img) {
                v.image = img;
            }
        }];*/
        [imgArray addObject:v];
    }];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.frame, point)) {
        return scrollViewCtl;
    }
    return [super hitTest:point withEvent:event];
}

@end
