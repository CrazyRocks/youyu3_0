//
//  MagCatalogueTableViewCell.m
//  TheReading
//
//  Created by mac on 15/4/22.
//  Copyright (c) 2015年 grenlight. All rights reserved.
//

#import "MagCatalogueTableViewCell.h"

@implementation MagCatalogueTableViewCell

- (void)awakeFromNib {
    // Initialization code

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 5, self.frame.size.width, kCellHeight)];
        //NSLog(@"\r\n width:%f", self.frame.size.width);
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleContent:(NSString *)titleContent {
    if (titleContent) {

        self.titleLabel.text = titleContent;
    }
}

@end
