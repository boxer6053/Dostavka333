#import "ProductDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SSToolkit/SSToolkit.h"
#import "checkConnection.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "ShareViewController.h"

@interface ProductDetailViewController () <UITextViewDelegate>
{
    BOOL isDownloadingPicture;
    BOOL isDeletingFromCart;
    BOOL isPictureViewContanerShow;
}

@property BOOL isInFavorites;
@property (strong, nonatomic) NSString *labelString;
@property (strong, nonatomic) UIAlertView *alert;
@property (nonatomic, strong) SSLoadingView *loadingView;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) GettingCoreContent *content;
@property (strong, nonatomic) NSString *currentEmail;
@property (strong, nonatomic) UIView *facebookLoginview;
@property (strong, nonatomic) UIButton *publishButton;
@property (strong, nonatomic) UIButton *authButton;

//titles
@property (strong, nonatomic) NSString *titleWihtDiscounts;
@property (strong, nonatomic) NSString *titleCancel;
@property (strong, nonatomic) NSString *titleAddetItemToTheCart;
@property (weak, nonatomic) NSString *titleYES;
@property (weak, nonatomic) NSString *titleNO;
@property (weak, nonatomic) NSString *titleDoYouWantDeleteItemFromCart;

@end

@implementation ProductDetailViewController
@synthesize db = _db;
@synthesize product = _product;
@synthesize countPickerView = _countPickerView;
@synthesize priceView = _priceView;
@synthesize cartButton = _cartButton;
@synthesize count = _count;
@synthesize shareButton = _addToFavorites;
@synthesize nameLabal = _nameLabal;
@synthesize pictureViewContainer = _pictureViewContainer;
@synthesize pictureButton = _pictureButton;
@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize captionLabel = _captionLabel;
@synthesize nilCaption = _nilCaption;
@synthesize proteinLabel = _proteinLabel;
@synthesize fatLabel = _fatLabel;
@synthesize carbohydratesLabel = _carbohydratesLabel;
@synthesize kCalLabel = _kCal;
@synthesize portionLabel = _portionLabel;
@synthesize portionProteinLabel = _portionProteinLabel;
@synthesize portionFatLabel = _portionFatLabel;
@synthesize portionCarbohydratesLabel = _portionCarbohydratesLabel;
@synthesize portionKCalLabel = _portionKCalLabel;
@synthesize in100gLabel = _in100gLabel;
@synthesize in100gProteinLabel = _in100gProteinLabel;
@synthesize in100gFatLabel = _in100gFatLabel;
@synthesize in100gCarbohydratesLabel = _in100gCarbohydratesLabel;
@synthesize in100gKCalLabel = _in100gKCalLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize weightLabel = _weightLabel;
@synthesize isInFavorites = _isInFavorites;
@synthesize labelString = _labelString;
@synthesize alert = _alert;
@synthesize loadingView = _loadingView;
@synthesize textView = _textView;
@synthesize titleAddetItemToTheCart = _titleAddetItemToTheCart;
@synthesize content = _content;
@synthesize currentEmail = _currentEmail;
@synthesize publishButton = _publishButton;

//titles
@synthesize titleWihtDiscounts = _titleWihtDiscounts;
@synthesize titleCancel = _titleCancel;
@synthesize titleYES = _titleYES;
@synthesize titleNO = _titleNO;
@synthesize titleDoYouWantDeleteItemFromCart = _titleDoYouWantDeleteItemFromCart;

- (void)setProduct:(ProductDataStruct *)product isFromFavorites:(BOOL)boolValue
{
    _product = product;
    self.isInFavorites = boolValue;
}

-(void)setLabelOfAddingButtonWithString:(NSString *)labelString withIndexPathInDB:(NSIndexPath *)indexPath
{
    self.labelString = labelString;
    [_product setCount:[NSNumber numberWithInt:0]];
}

- (IBAction)share:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
    [actionSheet setTitle:self.shareButton.titleLabel.text];
    [actionSheet setDelegate:(id)self];
    [actionSheet addButtonWithTitle:@"Twitter"];
    [actionSheet addButtonWithTitle:@"Facebook"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    [actionSheet showInView:self.view];
}

- (IBAction)showOrHidePictureViewContainer:(id)sender {
    if (!isPictureViewContanerShow) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.pictureViewContainer.frame = CGRectMake(35, -180, 250, 240);
        [UIView commitAnimations];
        
        [self.scrollView setHidden:NO];
        
        isPictureViewContanerShow = YES;
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.pictureViewContainer.frame = CGRectMake(35, 0, 250, 240);
        [UIView commitAnimations];

        isPictureViewContanerShow = NO;
    }
}

- (IBAction)dragPictureViewContainer:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = [sender translationInView:self.view];
    //    translation.y
    sender.view.center = CGPointMake(sender.view.center.x, sender.view.center.y + translation.y);
    
    if (sender.view.center.y >= 120) {
        sender.view.center = CGPointMake(sender.view.center.x, 120);
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        
        isPictureViewContanerShow = NO;
    } else if (sender.view.center.y <= -60) {
        sender.view.center = CGPointMake(sender.view.center.x, -60);
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        
        //        [self.scrollView setHidden:NO];
        
        isPictureViewContanerShow = YES;
        
    } else {
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        
        isPictureViewContanerShow = NO;
        
    }
}

- (GettingCoreContent *)content
{
    if(!_content)
       {
           _content = [[GettingCoreContent alloc] init];
       }
    return _content;
}

-(NSString* )findEmail
{
    NSArray *restaurantArray = [[NSArray alloc] initWithArray:[self.content getArrayFromCoreDatainEntetyName:@"Restaurants_translation" withSortDescriptor:@"underbarid"]];
        
    for (int i = 0; i < restaurantArray.count; i++)
    {
        if ([[[restaurantArray objectAtIndex:i] valueForKey:@"idRestaurant"] isEqualToString:[self.content fetchIdRestaurantFromIdMenu:self.product.idMenu]]) {
            _currentEmail = [[restaurantArray objectAtIndex:i] valueForKey:@"metro"];
            break;
        }
    }
    
    return _currentEmail;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self findEmail];
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:[NSString stringWithFormat:@"I like %@ from %@",self.product.title, _currentEmail]];
            [tweetSheet addImage:_product.image];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }

    }
    if (buttonIndex == 1)
    {
        [self findEmail];
        
        if(!self.facebookLoginview){
            self.facebookLoginview = [[UIView alloc] initWithFrame:self.view.frame];
            self.facebookLoginview.backgroundColor = [UIColor whiteColor];
        }
        UIImage *fbImageTitle = [UIImage imageNamed:@"facebookTitle.png"];
        UIImageView* fbImageTitleView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, fbImageTitle.size.width, fbImageTitle.size.height)];
        [fbImageTitleView setImage:fbImageTitle];
        [self.facebookLoginview addSubview:fbImageTitleView];
        
        UIImage *fbImage = [UIImage imageNamed:@"FBbackground.png"];
        UIImageView* fbImageView= [[UIImageView alloc] initWithFrame:CGRectMake(200, 300, fbImage.size.width, fbImage.size.height)];
        [fbImageView setImage:fbImage];
        [self.facebookLoginview addSubview:fbImageView];
        
        UIButton *exitButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 0, 35, 35)];
        [exitButton setImage:[UIImage imageNamed:@"close_x.png"] forState:UIControlStateNormal];
        [exitButton addTarget:self action:@selector(closeFacebookLoginView) forControlEvents:UIControlEventTouchUpInside];
        [self.facebookLoginview addSubview:exitButton];
        
        _authButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 200, 260, 40)];
        [_authButton setBackgroundImage:[UIImage imageNamed:@"fbButton.png"] forState:UIControlStateNormal];
        [_authButton addTarget:self action:@selector(authButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_authButton setTitle:@"Login" forState:UIControlStateNormal];
        [self.facebookLoginview addSubview:_authButton];
        
        _publishButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 250, 260, 40)];
        [_publishButton setBackgroundImage:[UIImage imageNamed:@"fbButton.png"] forState:UIControlStateNormal];
        [_publishButton addTarget:self action:@selector(goToFBSharingView:) forControlEvents:UIControlEventTouchUpInside];
        [_publishButton setTitle:@"Publish" forState:UIControlStateNormal];
        [_publishButton setHidden:YES];
        [self.facebookLoginview addSubview:_publishButton];
        
        [self.view addSubview:self.facebookLoginview];
    }
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


//////////////////////
#pragma mark FACEBOOK
//////////////////////
-(void) closeFacebookLoginView{
    [self.facebookLoginview removeFromSuperview];
}

-(void)authButtonAction:(id)sender
{
    RestaurantAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
    } else {
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toShare"]) {
        ShareViewController *shareViewController = segue.destinationViewController;
        shareViewController.imageLink = self.product.link;
        shareViewController.info = @"I like it in \"Dostavka 33 \"!";
        shareViewController.link = _currentEmail;
        shareViewController.name = self.product.title;
    }
}

-(void) goToFBSharingView:(id)sender
{
    [self performSegueWithIdentifier:@"toShare" sender:self];
}

- (GettingCoreContent *)db
{
    if(!_db)
    {
        _db = [[GettingCoreContent alloc] init];
    }
    return  _db;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setAllTitlesOnThisPage];
    
//FACEBOOK
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];

    RestaurantAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
    
//////////
    
    if (![self.db isRestaurantCanMakeOrderWithRestaurantID:[self.db fetchIdRestaurantFromIdMenu:self.product.idMenu]])
    {
        self.cartButton.hidden = YES;
        self.countPickerView.hidden = YES;
    }
    
    self.pictureViewContainer.frame = CGRectMake(35, -240, 250, 240);
    
    self.cartButton.titleLabel.textAlignment = UITextAlignmentCenter;
    self.nameLabal.text = self.product.title;
        
    self.portionProteinLabel.text = [NSString stringWithFormat:@"%5.1f", ((self.product.weight.floatValue * self.product.protein.floatValue) / 100)];
    self.portionFatLabel.text = [NSString stringWithFormat:@"%5.1f", ((self.product.weight.floatValue * self.product.fats.floatValue) / 100)];
    self.portionCarbohydratesLabel.text = [NSString stringWithFormat:@"%5.1f", ((self.product.weight.floatValue * self.product.carbs.floatValue) / 100)];
    self.portionKCalLabel.text = [NSString stringWithFormat:@"%5.1f", ((self.product.weight.floatValue * self.product.calories.floatValue) / 100)];



    
    self.in100gProteinLabel.text = [NSString stringWithFormat:@"%@",self.product.protein];
    self.in100gFatLabel.text = [NSString stringWithFormat:@"%@",self.product.fats];
    self.in100gCarbohydratesLabel.text = [NSString stringWithFormat:@"%@",self.product.carbs];
    self.in100gKCalLabel.text = [NSString stringWithFormat:@"%@",self.product.calories];
    
    self.weightLabel.text = [NSString stringWithFormat:@"%@%@%@%@",self.weightLabel.text, @" ", self.product.weight, @" g"];

    
    if ([self.product.descriptionText isEqualToString:@""]) {
        self.descriptionLabel.text = self.product.descriptionText;
    } else {

        if (self.product.descriptionText.length < 50) {
            
            [self.scrollView setScrollEnabled:NO];

        } else {
            
            NSString *str = self.product.descriptionText;
            
            int countStr = str.length / 25;
            
            [self.scrollView setScrollEnabled:YES];
            [self.scrollView setContentSize:CGSizeMake(250, 220 + (countStr - 2) * 15)];
            [self.scrollView setShowsVerticalScrollIndicator:NO];

        }
        self.descriptionLabel.text = self.product.descriptionText;
        [self.descriptionLabel sizeToFit];
    }
    
    NSString *str = self.product.descriptionText;
    NSLog(@"Довжина стрічки = %i",[str length]);
        
    self.countPickerView.frame = CGRectMake(237, 248, 63, 108);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingIncrement = [NSNumber numberWithDouble:0.01];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithFloat:(self.product.price.floatValue * [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrencyCoefficient"] floatValue])]];
    NSString *priceString = [NSString stringWithFormat:@"%@ %@", price, [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"]];
    
    NSArray *discountsArray = [self.db getArrayFromCoreDatainEntetyName:@"Discounts" withSortDescriptor:@"underbarid"];
    if (self.product.discountValue.floatValue >= 1)
    {
        for (int i = 0; i < discountsArray.count; i++)
        {
            if ([[[[discountsArray objectAtIndex:i] valueForKey:@"underbarid"] description] isEqual:self.product.discountValue])
            {
                self.product.discountValue = [[discountsArray objectAtIndex:i] valueForKey:@"value"];
                if ([[[[discountsArray objectAtIndex:i] valueForKey:@"value"] description] isEqual:@"0"])
                {
                    break;
                }
                else
                {
                    priceString = [NSString stringWithFormat:@"(<strike style=\"color:White;\">%@</strike>) %@ %@", price, [formatter stringFromNumber:[NSNumber numberWithFloat:(self.product.price.floatValue * (1 - self.product.discountValue.floatValue) * [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrencyCoefficient"] floatValue])]], [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"]];
                }
                break;
            }
        }
    }
    else
    {
        if (self.product.discountValue.floatValue != 0)
        priceString = [NSString stringWithFormat:@"(<strike style=\"color:White;\">%@</strike>) %@ %@", price, [formatter stringFromNumber:[NSNumber numberWithFloat:(self.product.price.floatValue * (1 - self.product.discountValue.floatValue) * [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrencyCoefficient"] floatValue])]], [[NSUserDefaults standardUserDefaults] objectForKey:@"Currency"]];
    }
    
    //self.priceLabel.text = priceString;
    NSString* htmlContentString = [NSString stringWithFormat:
                                   @"<html>"
                                   "<body style=\"font-family:Helvetica; font-size:14px;color:#FF7F00;text-align:left;\">"
                                   "<p>%@</p>"
                                   "</body></html>", priceString];
    
    self.priceView.opaque = NO;
    self.priceView.backgroundColor = [UIColor clearColor];
    [self.priceView loadHTMLString:htmlContentString baseURL:nil];
    
    self.imageView.frame = self.pictureButton.frame;
    
    if (self.product.image) {
        
        self.imageView.image = self.product.image;
        [self.pictureButton addSubview:self.imageView];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.pictureViewContainer.frame = CGRectMake(35, 0, 250, 240);
        [UIView commitAnimations];
        
        [self.scrollView setHidden:NO];

        
    } else {
        if (checkConnection.hasConnectivity) {
            
            self.loadingView = [[SSLoadingView alloc] initWithFrame:CGRectMake(0, 230, 250, 240)];
            self.loadingView.textLabel.text = @"";
            self.loadingView.backgroundColor = [UIColor clearColor];
            self.loadingView.activityIndicatorView.color = [UIColor whiteColor];
            self.loadingView.textLabel.textColor = [UIColor whiteColor];
            [self.pictureButton addSubview:self.loadingView];
        }
    }
    
    if (self.product.hit.integerValue == 1)
    {
        [self.imageView.layer addSublayer:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HIT1.png"]].layer];
    }
    else
        if (self.product.hit.integerValue == 2)
        {
            [self.imageView.layer addSublayer:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"New1.png"]].layer];
        }
        
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor darkGrayColor] CGColor],(id)[[UIColor blackColor] CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    if(self.product.isFavorites.boolValue)
    {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidAppear:(BOOL)animated
{
    if (!self.product.image && isDownloadingPicture == NO && checkConnection.hasConnectivity)
    {
        isDownloadingPicture = YES;
        [self performSelectorInBackground:@selector(downloadingPic) withObject:nil];
    }
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        self.publishButton.hidden = NO;
        [self.authButton setTitle:@"Logout" forState:UIControlStateNormal];
    } else {
        self.publishButton.hidden = YES;
        [self.authButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}

- (void)downloadingPic
{
    NSURL *url = [self.db fetchImageURLbyPictureID:self.product.idPicture];
    NSData *dataOfPicture = [NSData dataWithContentsOfURL:url];
    [self.db SavePictureToCoreData:self.product.idPicture toData:dataOfPicture];
    self.product.image  = [UIImage imageWithData:dataOfPicture];
    self.imageView.image = self.product.image;
    [self.loadingView removeFromSuperview];
    [self.imageView reloadInputViews];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.pictureViewContainer.frame = CGRectMake(35, 0, 250, 240);
    [UIView commitAnimations];
    
    [self.scrollView setHidden:NO];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)addToCart:(id)sender {
    
    if (self.product.count.intValue == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[NSString stringWithFormat:self.titleDoYouWantDeleteItemFromCart, self.product.title]
                                                       delegate:self
                                              cancelButtonTitle:self.titleYES
                                              otherButtonTitles:self.titleNO, nil];
        [alert show];
        isDeletingFromCart = YES;
        
    }
    else
    {
        [self.db SaveProductToEntityName:@"Cart" WithId:self.product.productId
                               withCount:self.product.count.integerValue
                               withPrice:self.product.price.floatValue
                             withPicture:UIImagePNGRepresentation(self.product.image)
                       withDiscountValue:self.product.discountValue.floatValue
                              withWeight:self.product.weight
                             withProtein:self.product.protein withCarbs:self.product.carbs
                                withFats:self.product.fats
                            withCalories:self.product.calories
                             isFavorites:self.product.isFavorites.boolValue
                                   isHit:NO
                              withIdMenu:self.product.idMenu];
        
        self.alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:self.titleAddetItemToTheCart,self.product.count.integerValue, self.product.title] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [self. alert show];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && isDeletingFromCart == YES)
    {
        [self.db deleteObjectFromEntity:@"Cart" withProductId:self.product.productId];
        NSLog(@"deleted");
        [self.navigationController popViewControllerAnimated:NO];
    }
}
- (IBAction)AddToFavorites:(id)sender
{
    // add to favorites here
    id currentOne = self.product;
    //changing is database
    [self.db changeFavoritesBoolValue:![[currentOne isFavorites] boolValue] forId:[currentOne productId]];
    //changing in Array
    [currentOne setIsFavorites:[NSNumber numberWithBool:![[currentOne isFavorites] boolValue]]];
    
    if ([currentOne isFavorites].boolValue)
    {
        self.alert = [[UIAlertView alloc] initWithTitle:nil
                                                message:[NSString stringWithFormat:@"Added \"%@\" to favorites.", [currentOne title]]
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
    }
    else
    {
        self.alert = [[UIAlertView alloc] initWithTitle:nil
                                                message:[NSString stringWithFormat:@"Removed \"%@\" from favorites.", [currentOne title]]
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
    }
    
    [self.alert show];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];

}

- (void) dismiss
{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    [self setAlert:nil];
}



- (void)viewDidUnload
{
    [self setCountPickerView:nil];
    [self setPriceView:nil];
    [self setCartButton:nil];
    [self setShareButton:nil];
    [self setNameLabal:nil];
    [self setAlert:nil];
    
    [self setLoadingView:nil];
    [self setDb:nil];
    [self setProduct:nil];

    [self setPictureViewContainer:nil];
    [self setPictureButton:nil];
    [self setImageView:nil];
    [self setScrollView:nil];
    [self setCaptionLabel:nil];
    [self setNilCaption:nil];
    [self setProteinLabel:nil];
    [self setFatLabel:nil];
    [self setCarbohydratesLabel:nil];
    [self setKCalLabel:nil];
    [self setPortionLabel:nil];
    [self setPortionProteinLabel:nil];
    [self setPortionFatLabel:nil];
    [self setPortionCarbohydratesLabel:nil];
    [self setPortionKCalLabel:nil];
    [self setIn100gLabel:nil];
    [self setIn100gProteinLabel:nil];
    [self setIn100gFatLabel:nil];
    [self setIn100gCarbohydratesLabel:nil];
    [self setIn100gKCalLabel:nil];
    [self setDescriptionLabel:nil];
    [self setWeightLabel:nil];
    [self setFavoritesButton:nil];
    [self setPriceView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.labelString)
        return 21;
    else
        return 20;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *rowNumber;
    if (self.labelString)
    {
        rowNumber = [[NSString alloc] initWithFormat:@"%i", row];
    }
    else
    {
        rowNumber = [[NSString alloc] initWithFormat:@"%i", row+1];
    }
    return rowNumber;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.labelString)
        self.product.count = [NSNumber numberWithInt:row];
    else 
        self.product.count = [NSNumber numberWithInt:row+1];
}


#pragma mark
#pragma mark PRIVATE METHODS

-(void)setAllTitlesOnThisPage
{
    NSArray *array = [Singleton titlesTranslation_withISfromSettings:NO];
    for (int i = 0; i <array.count; i++)
    {
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"the nutritional values"])
        {
            self.captionLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"portion"])
        {
            self.portionLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"protein"])
        {
            self.proteinLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"in 100g"])
        {
            self.in100gLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"fat"])
        {
            self.fatLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"carbohydrate"])
        {
            self.carbohydratesLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Weight"])
        {
            self.weightLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Add favorites"])
        {
            self.favoritesButton.title = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if (!self.labelString && [[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Add to Cart"])
        {
            [self.cartButton setTitle:[[array objectAtIndex:i] valueForKey:@"title"] forState:UIControlStateNormal];
        }
        
        else if (self.labelString && [[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Change"])
        {
            [self.cartButton setTitle:[[array objectAtIndex:i] valueForKey:@"title"] forState:UIControlStateNormal];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Share"])
        {
            [self.shareButton setTitle:[[array objectAtIndex:i] valueForKey:@"title"] forState:UIControlStateNormal];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"with discount"])
        {
            self.titleWihtDiscounts = [[array objectAtIndex:i] valueForKey:@"title"];
        }

        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Cancel"])
        {
            self.titleCancel = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Added %i item(s) %@ to the Cart."])
        {
            self.titleAddetItemToTheCart = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Do you want to delete item %@"])
        {
            self.titleDoYouWantDeleteItemFromCart = [[array objectAtIndex:i] valueForKey:@"title"];
        }
    
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"YES"])
        {
            self.titleYES = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"NO"])
        {
            self.titleNO = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        else if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Loading..."])
        {
            self.loadingView.textLabel.text = [[array objectAtIndex:i] valueForKey:@"title"];
        }
    }
}


@end
