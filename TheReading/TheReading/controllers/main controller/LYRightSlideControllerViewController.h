//
//  LYRightSlideControllerViewController.h
//  TheReading
//
//  Created by grenlight on 12/6/14.
//  Copyright (c) 2014 grenlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OWKit/OWCommonTableViewController.h>
#import "WYContentCanvasController.h"
#import "LYPersonPageIconView.h"
#import "OfflineViewController.h"

@interface LYRightSlideControllerViewController : OWCommonTableViewController <LYPersonPageIconView>
{
    IBOutlet UIView *headerView;
    __weak IBOutlet UIImageView *logoImageView, *headerBgImageView, *bgImageView;
    __weak IBOutlet UILabel  *displayNameLB, *unitNameLB, *cellPhoneLB;
    
    IBOutlet UIView *contentView;
    __weak IBOutlet NSLayoutConstraint *bgLeftConstraint;
}
@property (nonatomic, weak) WYContentCanvasController *contentCanvasController;

- (IBAction)blanckClick:(id)sender;

@end
