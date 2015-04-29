//
//  SubNavigationBar.m
//  GoodSui
//
//  Created by 龙源 on 13-6-18.
//  Copyright (c) 2013年 grenlight. All rights reserved.
//

#import "OWSubNavigationBar.h"
#import "PathStyleGestureController.h"
#import "UIStyleManager.h"
#import "OWImage.h"
#import "OWNavCategoryView.h"

@implementation OWSubNavigationItem
@end


@implementation OWSubNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
   self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];

    }
    return self;
}

- (void)setup
{
    style = [[UIStyleManager sharedInstance] getStyle:@"分类子导航"];
    self.backgroundColor = style.background;
}

- (void)dealloc
{
    self.srcollViewSub.delegate = Nil;
}

- (void)createScrollView
{
    if (self.srcollViewSub) {
        [self.srcollViewSub removeFromSuperview];
        self.srcollViewSub.delegate = nil;
        self.srcollViewSub = nil;
    }
    self.srcollViewSub = [[UIScrollView alloc] init];
    self.srcollViewSub.delegate = self;
    self.srcollViewSub.showsHorizontalScrollIndicator = NO;
    self.srcollViewSub.scrollEnabled = YES;
    self.srcollViewSub.bounces = YES;
    self.srcollViewSub.alwaysBounceHorizontal = NO;
    self.srcollViewSub.alwaysBounceVertical  = NO;
    
    CGRect frame = self.bounds;
    frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y
                       , CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    frame.size.height -= 1;
    [self.srcollViewSub setFrame:frame];
    self.srcollViewSub.backgroundColor = self.backgroundColor;
    self.srcollViewSub.contentInset = [self.delegate subNavigationBarEdgeInsets];
    
    self.srcollViewSub.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.srcollViewSub];
}

- (void)renderItems:(NSArray *)array
{
    dataSource = [array copy];
    
    [self createScrollView];
    
    __block float offSetX = 0,
    width = [self.delegate navigationBarItemWidth],
    height = CGRectGetHeight(self.srcollViewSub.bounds);
    __block int index = 0;

    if (buttons) {
        while (buttons.count > 0) {
            UIButton *bt = buttons.lastObject;
            [bt removeFromSuperview];
            [bt removeTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [buttons removeObject:bt];
        }
        selectedButton = nil;
    }
    buttons = [[NSMutableArray alloc] init];
    
    void(^generateButton)(NSString *) = ^(NSString *title){
        offSetX = width *index;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        [button setFrame:CGRectMake(offSetX, 0, width, height)];
        [self.srcollViewSub addSubview:button];
        
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button setTitleColor:style.fontColor forState:UIControlStateNormal];
        [button setTitleColor:style.fontColor_selected forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *imgSelect = [UIImage imageNamed:@"BgSelectedOnChannel.png"];
        [button setBackgroundImage:imgSelect forState:UIControlStateSelected];
        [buttons addObject:button];
    };
    
    for (OWSubNavigationItem *cat in array) {
        generateButton(cat.catName);
        index ++;
    }
    self.srcollViewSub.contentSize = CGSizeMake(width * array.count, height);
    if (selectedCategoryID) {
        for (int i=0; i<dataSource.count; i++) {
            OWSubNavigationItem *cat = dataSource[i];
            if ([cat.catID isEqualToString:selectedCategoryID]) {
                UIButton *button = buttons[i];
                [self buttonTapped:button];
                return;
            }
        }
    }
    if (buttons && buttons.count > 0) {
        UIButton *button = buttons[0];
        [self buttonTapped:button]; 
    }
}

- (void)renderItems:(NSArray *)array selectedIndex:(NSInteger)index
{
    selectedCategoryID = ((OWSubNavigationItem *)array[index]).catID;
    [self renderItems:array];
}

- (void)setSelectedIndex:(NSInteger)index
{
    [selectedButton setSelected:NO];
    UIButton *button = buttons[index];
    [button setSelected:YES];
    selectedButton = button;
    selectedCategoryID = ((OWSubNavigationItem *)dataSource[button.tag]).catID;

    [self changeOffsetByCurrentItem:button];
}

- (void)autoTapByIndex:(NSInteger)index
{
    [self setSelectedIndex:index];
    
    if (self.delegate) {
        [self.delegate navigationBarSelectedItem:selectedCategoryID itemIndex:index];
    }
}

- (void)buttonTapped:(UIButton *)sender
{
    NSInteger indexTag;
    self.userInteractionEnabled = NO;
    if (sender == nil) {
        indexTag = 0;
    } else {
        indexTag = sender.tag;
    }
    [self autoTapByIndex:indexTag];
    
    [self performSelector:@selector(interactionEnabled) withObject:nil afterDelay:1.0];
}

- (void)interactionEnabled
{
    self.userInteractionEnabled = YES;
}

- (void)changeOffsetByCurrentItem:(UIButton *)sender
{
    if (!sender) return;
    
    CGRect frame = self.bounds;
    frame.size.width -=  self.srcollViewSub.contentInset.right;
    
    float centerX = CGRectGetMidX(frame);

    float maxOffsetX = self.srcollViewSub.contentSize.width - (CGRectGetWidth(frame));
    if (maxOffsetX < 0) {
        maxOffsetX = 0;
    }
    
    if (sender.center.x < centerX) {
        [self.srcollViewSub setContentOffset:CGPointZero animated:YES];
    }
    else {
        float distanceX = sender.center.x - centerX;
        CGRect vFrame = frame;
        
        if (distanceX < maxOffsetX) {
            vFrame.origin.x = distanceX;
        }
        else {
            vFrame.origin.x = maxOffsetX;
        }
        [self.srcollViewSub setContentOffset:vFrame.origin animated:YES];
    }
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, style.hLineWidth);
    CGContextSetStrokeColorWithColor(context, style.hLineColor.CGColor);
    CGContextMoveToPoint(context, 0, CGRectGetHeight(self.bounds) - style.hLineWidth/2.0f);
    CGContextAddLineToPoint(context, rect.size.width,  CGRectGetHeight(self.bounds)- style.hLineWidth/2.0f);
    CGContextDrawPath(context, kCGPathStroke );
}

#pragma mark scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[PathStyleGestureController sharedInstance] cancelAnyGestureRecognize];
}

@end
