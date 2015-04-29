//
//  RecommendArticleSimpleTableCellSimple.h
//  TheReading
//
//  Created by mac on 15/4/27.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OWCoreText/OWCoreText.h>
#import <OWCoreText/OWInfiniteCoreTextLayouter.h>
#import <OWKit/OWKit.h>
#import "LYMagazinesStand.h"

@interface RecommendArticleSimpleTableCellSimple : UITableViewCell {
    __weak  LYArticleTableCellData  *contentInfo;
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

- (void)setContent:(LYArticleTableCellData *)info;
-(void)rerenderContent;

@end
