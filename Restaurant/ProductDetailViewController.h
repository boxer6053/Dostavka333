#import <UIKit/UIKit.h>
#import "ProductDataStruct.h"
#import "GettingCoreContent.h"
#import <Twitter/Twitter.h>
#import "Singleton.h"
#import "RestaurantAppDelegate.h"

@interface ProductDetailViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate>

@property (strong, nonatomic) ProductDataStruct *product;
@property (strong, nonatomic) GettingCoreContent *db;
@property (strong, nonatomic) NSNumber *count;
@property (weak, nonatomic) IBOutlet UIPickerView *countPickerView;
@property (weak, nonatomic) IBOutlet UIWebView *priceView;
@property (weak, nonatomic) IBOutlet UIButton *cartButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabal;
@property (weak, nonatomic) IBOutlet UIView *pictureViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *nilCaption;
@property (weak, nonatomic) IBOutlet UILabel *proteinLabel;
@property (weak, nonatomic) IBOutlet UILabel *fatLabel;
@property (weak, nonatomic) IBOutlet UILabel *carbohydratesLabel;
@property (weak, nonatomic) IBOutlet UILabel *kCalLabel;
@property (weak, nonatomic) IBOutlet UILabel *portionLabel;
@property (weak, nonatomic) IBOutlet UILabel *portionProteinLabel;
@property (weak, nonatomic) IBOutlet UILabel *portionFatLabel;
@property (weak, nonatomic) IBOutlet UILabel *portionCarbohydratesLabel;
@property (weak, nonatomic) IBOutlet UILabel *portionKCalLabel;
@property (weak, nonatomic) IBOutlet UILabel *in100gLabel;
@property (weak, nonatomic) IBOutlet UILabel *in100gProteinLabel;
@property (weak, nonatomic) IBOutlet UILabel *in100gFatLabel;
@property (weak, nonatomic) IBOutlet UILabel *in100gCarbohydratesLabel;
@property (weak, nonatomic) IBOutlet UILabel *in100gKCalLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *favoritesButton;

- (void)setProduct:(ProductDataStruct *)product isFromFavorites:(BOOL)boolValue;

-(void)setLabelOfAddingButtonWithString:(NSString *)labelString withIndexPathInDB:(NSIndexPath *)indexPath;
- (IBAction)share:(id)sender;
- (IBAction)showOrHidePictureViewContainer:(id)sender;
- (IBAction)dragPictureViewContainer:(UIPanGestureRecognizer *)sender;

- (IBAction)authButtonAction:(id)sender;
@end
