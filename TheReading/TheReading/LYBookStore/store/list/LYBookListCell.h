//
//  LYBookListCell.h
//  LYBookStore
//
//  Created by grenlight on 14-5-7.
//  Copyright (c) 2014年 OOWWWW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OWKit/OWBottomAlignImageView.h>
#import <OWLabel.h>
#import "LYBookItemData.h"

@interface LYBookListCell : UICollectionViewCell
{
    IBOutlet OWBottomAlignImageView  *webImageView;
    //IBOutlet OWLabel  *bookNameLB;
    
    //IBOutlet NSLayoutConstraint *titleHeightConstraint;
    NSInteger   downloadStatus;
    
}
- (void)setContent:(NSDictionary *)info ;

@end
