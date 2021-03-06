//
//  MenuIconViewController.h
//  Restaurant
//
//  Created by Matrix Soft on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GettingCoreContent.h"
#import "MenuDataStruct.h"
#import "IconDownloader.h"
#import "Singleton.h"
#import "ProductCell.h"
#import "ProductDataStruct.h"
#import "ProductDetailViewController.h"
#import "GMGridViewLayoutStrategies.h"




#import <QuartzCore/QuartzCore.h>
#import "GMGridView.h"
//#import "OptionsViewController.h"


#import "SSToolkit/SSToolkit.h"

@interface MenuIconViewController : UIViewController <UIScrollViewDelegate, GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate, IconDownloaderDelegate>

@property (strong, nonatomic) NSMutableArray *arrayData;
@property (strong, nonatomic) NSDictionary *currentPictures;
@property (nonatomic, strong) MenuDataStruct *kindOfMenu;
@property (strong, nonatomic) GettingCoreContent *db;
@property (strong, nonatomic) GMGridView *gmGridView;
@property (strong, nonatomic) IBOutlet UIView *viewForOutput;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *stopEditButton;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (strong, nonatomic) NSNumber *selectedIndex;

- (IBAction)changePage;
- (void)toCartMenu:(id)sender;
- (IBAction)stopEditing:(id)sender;

@end
