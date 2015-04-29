//
//  OfflineViewController.h
//  PublicLibrary
//
//  Created by grenlight on 14-5-29.
//  Copyright (c) 2014年 grenlight. All rights reserved.
//

#import <OWKit/OWKit.h>

typedef enum {
    PAGE_INTO_BOOK_DOWNLOAD,
    PAGE_INTO_MAGAZINE_DOWNLOAD,
    PAGE_INTO_ATTENTION
}Page_into_subview;

@interface OfflineViewController : XibAdaptToScreenController
{
   __weak IBOutlet KWFSegmentedControl *segmentControl;
}
@property (nonatomic, copy) ReturnMethod returnToPreController;

@property (nonatomic) NSInteger pageIndex;
- (IBAction)segmentedValueChanged:(id)sender;

@end
