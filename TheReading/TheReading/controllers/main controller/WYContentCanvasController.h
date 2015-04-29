//
//  WYContentCanvasController.h
//  PublicLibrary
//
//  Created by grenlight on 14-1-24.
//  Copyright (c) 2014年 grenlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OWKit/OWKit.h>

@interface WYContentCanvasController : XibAdaptToScreenController
{
    __weak IBOutlet UIView *contentView, *magsStandCanvas;
    __weak IBOutlet UIButton    *leftButton;
    
    NSMutableDictionary     *controllers;
    
    LYMenuData              *currentMenu;
}


@property (strong, nonatomic) IBOutlet UIButton *accountButton;
- (void)setNavTitle:(NSString *)title;

- (IBAction)menuTapped:(id)sender;
- (IBAction)accountTapped:(id)sender;

- (void)intoMagazineStore;
- (void)intoArticleSearch;
- (void)intoFavoriteList;
- (void)intoAttentionView;
- (void)intoBookStore;

- (void)intoOffline;
- (void)intoAudio;
- (void)intoOfflineByIndex: (NSInteger)index;
- (void)openMenu:(LYMenuData *)menu;

//除了导航，不响应其它事件
- (void)intoFreeze;
- (void)outFreeze;

@end
