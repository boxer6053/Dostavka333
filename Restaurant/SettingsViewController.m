//
//  SettingsViewController.m
//  Restaurant
//
//  Created by Roman Slysh on 9/27/12.
//
//

#import "SettingsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>

@interface SettingsViewController () <FBLoginViewDelegate, UITextViewDelegate>
{
    BOOL isStyle;
    BOOL isCurrency;
    BOOL isFriend;
}

@property (nonatomic, strong) NSArray *currencyArray;

//Titles
@property (nonatomic, strong) NSString *titleSettings;
@property (nonatomic, strong) NSString *titleLanguage;
@property (nonatomic, strong) NSString *titleCity;
@property (nonatomic, strong) NSString *titleMenuStyle;
@property (nonatomic, strong) NSString *titleCurrency;
@property (nonatomic, strong) NSString *titleShare;
@property (nonatomic, strong) NSString *titleTellFriend;
@property (nonatomic, strong) NSString *titleAbout;

@property (nonatomic, strong) NSString *titleStyle;//для двох наступних
@property (nonatomic, strong) NSString *titleIcons;
@property (nonatomic, strong) NSString *titleList;

@property (nonatomic, strong) NSString *titleChooseStyle;
@property (nonatomic, strong) NSString *titleSetCurrency;
@property (nonatomic, strong) NSString *titleSosialNetworks;
@property (nonatomic, strong) NSString *titleCancel;

@property (strong, nonatomic) UIView *facebookView;
@property (strong, nonatomic) FBProfilePictureView *fbProfilePictureView;
@property (strong, nonatomic) FBLoginView *loginview;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *postOnWallButton;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

@end

@implementation SettingsViewController

@synthesize currencyArray = _currencyArray;
@synthesize loggedInUser = _loggedInUser;

//Titles
@synthesize titleSettings = _titleSettings;
@synthesize titleLanguage = _titleLanguage;
@synthesize titleCity = _titleCity;
@synthesize titleMenuStyle = _titleMenuStyle;
@synthesize titleCurrency = _titleCurrency;
@synthesize titleShare = _titleShare;
@synthesize titleTellFriend = _titleTellFriend;
@synthesize titleAbout = _titleAbout;
@synthesize titleStyle = _titleStyle;

@synthesize titleChooseStyle = _titleChooseStyle;
@synthesize titleSetCurrency = _titleSetCurrency;
@synthesize titleSosialNetworks = _titleSosialNetworks;
@synthesize titleCancel = _titleCancel;

#pragma mark - Life circle

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [self setAllTitlesOnThisPage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setAllTitlesOnThisPage];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"typeOfView"] isEqualToString:@"menuIcon"])
        self.titleStyle = self.titleIcons;
    else
        self.titleStyle = self.titleList;
    
    [self.navigationItem.titleView reloadInputViews];
    self.navigationItem.title = self.titleSettings;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return 4;
        }
        case 1:
        {
            return 2;
        }
            
        default:
        {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    
//    cell.textLabel.text = @"Test";
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                cell.textLabel.text = self.titleLanguage;
                GettingCoreContent *content = [[GettingCoreContent alloc] init];
                NSArray *languages =  content.fetchAllLanguages;
                NSString *userLangId = [[NSUserDefaults standardUserDefaults] valueForKey:@"defaultLanguageId"];
                
                for (int i = 0; i < languages.count; i++)
                {
                    if ([[[[languages objectAtIndex:i] valueForKey:@"underbarid"] description] isEqualToString:userLangId.description])
                    {
                        cell.detailTextLabel.text = [[languages objectAtIndex:i] valueForKey:@"language"];
                    }
                }
                break;
            }
            case 1:
            {
                cell.textLabel.text = self.titleCity;
                GettingCoreContent *content = [[GettingCoreContent alloc] init];
                NSArray *cities =  [content fetchAllCitiesByLanguage:[[[NSUserDefaults standardUserDefaults] valueForKey:@"defaultLanguageId"] description]];
                NSString *userCityId = [[[NSUserDefaults standardUserDefaults] valueForKey:@"defaultCityId"] description];
                for (int i = 0; i < cities.count; i++)
                {
                    if ([[[NSString stringWithFormat:@"%@",[[cities objectAtIndex:i] valueForKey:@"idCity"]] description] isEqual:userCityId.description])
                        cell.detailTextLabel.text = [[cities objectAtIndex:i] valueForKey:@"name"];
                }
                break;
            }
            case 2:
                cell.textLabel.text = self.titleMenuStyle;
                cell.detailTextLabel.text = self.titleStyle;
                break;
            case 3:
                cell.textLabel.text = self.titleCurrency;
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Currency"];
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = self.titleShare;
                break;
                
            case 1:
                cell.textLabel.text = self.titleTellFriend;
                break;
        }
    }
    else
    {
        cell.textLabel.text = self.titleAbout;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                [self performSegueWithIdentifier:@"to Languages" sender:self];
                break;
            }
            case 1:
            {
                [self performSegueWithIdentifier:@"to Cities" sender:self];
                break;
            }
            case 2:
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
                [actionSheet setTitle:self.titleChooseStyle];
                [actionSheet setDelegate:(id)self];
                isStyle = YES;
                [actionSheet addButtonWithTitle:self.titleIcons];
                [actionSheet addButtonWithTitle:self.titleList];
                [actionSheet addButtonWithTitle:self.titleCancel];
                actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
                [actionSheet showInView:self.view];
                break;
            }
            case 3:
            {
                GettingCoreContent *db = [[GettingCoreContent alloc] init];
                self.currencyArray = [NSArray arrayWithArray:[db getArrayFromCoreDatainEntetyName:@"Currencies" withSortDescriptor:@"underbarid"]];
                
                UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
                [actionSheet setTitle:self.titleSetCurrency];
                [actionSheet setDelegate:(id)self];
                isCurrency = YES;
                
                for (int i = 0; i < self.currencyArray.count; i++)
                {
                    [actionSheet addButtonWithTitle:[[self.currencyArray objectAtIndex:i] valueForKey:@"currency"]];
                }
                
                [actionSheet addButtonWithTitle:self.titleCancel];
                actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
                
                [actionSheet showInView:self.view];
                
                break;
            }
        }
    }
    else if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
                [actionSheet setTitle:self.titleSosialNetworks];
                [actionSheet setDelegate:(id)self];
                [actionSheet addButtonWithTitle:@"Twitter"];
                [actionSheet addButtonWithTitle:@"Facebook"];
                [actionSheet addButtonWithTitle:self.titleCancel];
                actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
                [actionSheet showInView:self.view];
                
                break;
            }
                
            case 1:
            {
                UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
                [actionSheet setTitle:self.titleTellFriend];
                [actionSheet setDelegate:(id)self];
                isFriend = YES;
                [actionSheet addButtonWithTitle:@"SMS"];
                [actionSheet addButtonWithTitle:@"E-mail"];
                [actionSheet addButtonWithTitle:self.titleCancel];
                actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
                
                [actionSheet showInView:self.view];
                
                break;
            }
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"About" sender:self];
    }

}

#pragma mark - Action view delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex == buttonIndex)
    {
        isFriend = 0;
        isStyle = 0;
        isCurrency = 0;
        return;
    }
    else if (isFriend)
    {
        if (buttonIndex == 0)
        {
            NSLog(@"SMS");
            isFriend = 0;
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
            if([MFMessageComposeViewController canSendText])
            {
                controller.body = @"I downloaded \"Доставка 33\" from AppStore and I like it! :) \n https://itunes.apple.com/us/app/dostavka-33/id571980030?ls=1&mt=8";
                controller.recipients = [NSArray arrayWithObjects:/*phone numbers*/nil];
                controller.messageComposeDelegate = (id)self;
                [self presentModalViewController:controller animated:YES];
            }
        }
        if (buttonIndex == 1)
        {
            NSLog(@"Email");
            isFriend = 0;
            
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            if (mailClass != nil)
            {
                // We must always check whether the current device is configured for sending emails
                if ([mailClass canSendMail])
                {
                    [self displayComposerSheet];
                }
                else
                {
                    [self launchMailAppOnDevice];
                }
            }
            else
            {
                [self launchMailAppOnDevice];
            }
        }
    }
    
    else if (!isStyle && !isFriend && !isCurrency)
    {
        if (buttonIndex == 0)
        {
            //Twitter
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                NSString* url = @"https://itunes.apple.com/us/app/dostavka-33/id571980030?ls=1&mt=8";
                [tweetSheet setInitialText:@"I downloaded \"Доставка 33\" from AppStore and I like it! :)"];
                [tweetSheet addURL:[NSURL URLWithString:url]];
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
            //Facebook
            [self.navigationController setNavigationBarHidden:YES animated:NO];
            
            if (!self.facebookView)
            {
                self.facebookView = [[UIView alloc] initWithFrame:self.view.frame];
                self.facebookView.backgroundColor = [UIColor whiteColor];
            }
            
            
            if (!self.loginview)
            {
                self.loginview = [[FBLoginView alloc] initWithReadPermissions:[NSArray arrayWithObject:@"status_update"]];
                self.loginview.frame = CGRectOffset(self.loginview.frame, 5, 5);
                self.loginview.delegate = self;
                [self.loginview sizeToFit];
                [self.facebookView addSubview:self.loginview];
            }
            
            
            if (!self.fbProfilePictureView)
            {
                self.fbProfilePictureView = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(20, 70, 100, 100)];
                [self.facebookView addSubview:self.fbProfilePictureView];
            }
            
            
            self.textView = [[UITextView alloc] initWithFrame:CGRectMake(127, 70, 173, 100)];
            [self.facebookView addSubview:self.textView];
            self.textView.text = @"I downloaded \"Доставка 33\" from AppStore and I like it! :) \n https://itunes.apple.com/us/app/dostavka-33/id571980030?ls=1&mt=8";
            [self.textView setReturnKeyType:UIReturnKeyDone];
            [self.textView setDelegate:self];
            [self.textView.layer setBorderColor:[[UIColor colorWithRed:59.0f/255.0f green:89.0f/255.0f blue:182.0f/255.0f alpha:1.0f] CGColor]];
            [self.textView.layer setBorderWidth:2];
            [self.textView.layer setCornerRadius:2];
            
            UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
            exitButton.frame = CGRectMake(280, 0, 35, 35);
            [exitButton setImage:[UIImage imageNamed:@"close_x.png"] forState:UIControlStateNormal];
            [exitButton addTarget:self action:@selector(removeMySelf) forControlEvents:UIControlEventTouchUpInside];
            [self.facebookView addSubview:exitButton];
            
            self.postOnWallButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            self.postOnWallButton.frame = CGRectMake(84, 307, 150, 37);
            [self.postOnWallButton setTitle:@"Post on timeline" forState:UIControlStateNormal];
            [self.postOnWallButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
            [self.postOnWallButton addTarget:self action:@selector(postOnWall) forControlEvents:UIControlEventTouchUpInside];
            [self.facebookView addSubview:self.postOnWallButton];
            
            [self.view addSubview:self.facebookView];
        }
        
    }
    
    else if (isStyle)
    {
        if (buttonIndex == 0)
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"toFavoritesIcon" forKey:@"typeOfViewFavorites"];
            [[NSUserDefaults standardUserDefaults] setValue:@"menuIcon" forKey:@"typeOfView"];
            self.titleStyle = self.titleIcons;
            
        }
        if (buttonIndex == 1)
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"toFavoritesList" forKey:@"typeOfViewFavorites"];
            [[NSUserDefaults standardUserDefaults] setValue:@"menuList" forKey:@"typeOfView"];
            self.titleStyle = self.titleList;
        }
        isStyle = 0;
    }
    
    else if (isCurrency)
    {
        for (int i = 0; i <self.currencyArray.count; i++)
        {
            if (buttonIndex == i)
            {
                [[NSUserDefaults standardUserDefaults] setValue:[[self.currencyArray objectAtIndex:i] valueForKey:@"currency"] forKey:@"Currency"];
                [[NSUserDefaults standardUserDefaults] setValue:[[self.currencyArray objectAtIndex:i] valueForKey:@"coef"] forKey:@"CurrencyCoefficient"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
            }
        }
//        self.currencyCell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Currency"];
    }
    
    [self.tableView reloadData];
    
}
- (void) postOnWall
{
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.frame = self.facebookView.frame;
    [self.facebookView addSubview:self.indicator];
    [self.indicator startAnimating];
    
    
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_stream"] == NSNotFound)
    {
        // No permissions found in session, ask for it
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_stream"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error)
         {
             // If permissions granted, publish the story
             if (!error)[self postToFB:_textView.text];
         }];
    }
    // If permissions present, publish the story
    else [self postToFB:_textView.text];
}

- (void) postToFB:(NSString*)message
{
    [FBRequestConnection startForPostStatusUpdate:message
                                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                        
                              NSString *alertText;
                              if (error) {
                                  alertText = [NSString stringWithFormat:
                                               @"error: domain = %@, code = %d",
                                               error.domain, error.code];
                                  [_indicator stopAnimating];
                                  [self.facebookView removeFromSuperview];
                                  [self.navigationController setNavigationBarHidden:NO animated:NO];
                              } else {
                                  alertText = [NSString stringWithFormat:@"Posted successfully"];
                                  [_indicator stopAnimating];
                                  [self.facebookView removeFromSuperview];
                                  [self.navigationController setNavigationBarHidden:NO animated:NO];
                              }
                              [[[UIAlertView alloc] initWithTitle:@"Result"
                                                          message:alertText
                                                         delegate:self
                                                cancelButtonTitle:@"OK!"
                                                otherButtonTitles:nil] show];
                          }];
}

- (void)removeMySelf
{
    [self.facebookView removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.indicator)
        [self.indicator stopAnimating];
}
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"In");
    self.postOnWallButton.enabled = YES;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"Out");
    self.postOnWallButton.enabled = NO;
    self.fbProfilePictureView.profileID = nil;
}
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    self.fbProfilePictureView.profileID = user.id;
    self.loggedInUser = user; 
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"to Languages"])
    {
        [[segue destinationViewController] setArrayFromSegue:NO];
        [[[segue destinationViewController] navigationItem] setTitle:self.titleLanguage];
        NSLog(@"LANGUAGES");
    }
    
    if ([[segue identifier] isEqualToString:@"to Cities"])
    {
        [[segue destinationViewController] setArrayFromSegue:YES];
        [[[segue destinationViewController] navigationItem] setTitle:self.titleCity];
        NSLog(@"CITIES");
    }
}

#pragma mark
#pragma mark PRIVATE METHODS

-(void)setAllTitlesOnThisPage
{
    NSArray *array = [Singleton titlesTranslation_withISfromSettings:NO];
    for (int i = 0; i <array.count; i++)
    {
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Settings"])
        {
            self.titleSettings = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Language"])
        {
            self.titleLanguage = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"City"])
        {
            self.titleCity = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Menu style"])
        {
            self.titleMenuStyle = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Currency"])
        {
            self.titleCurrency = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Share"])
        {
            self.titleShare = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Tell a friend"])
        {
            self.titleTellFriend = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"About"])
        {
            self.titleAbout = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Choose style"])
        {
            self.titleChooseStyle = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Icons"])
        {
            self.titleIcons = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"List"])
        {
            self.titleList = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Set currency"])
        {
            self.titleSetCurrency = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Social networks"])
        {
            self.titleSosialNetworks = [[array objectAtIndex:i] valueForKey:@"title"];
        }
        
        if ([[[array objectAtIndex:i] valueForKey:@"name_EN"] isEqualToString:@"Cancel"])
        {
            self.titleCancel = [[array objectAtIndex:i] valueForKey:@"title"];
        }
    }
}



#pragma mark -
#pragma mark SMS Mail

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result)
    {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
        {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Unknown Error"
														   delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
			[alert show];
			break;
        }
		case MessageComposeResultSent:
            NSLog(@"Sent");
			break;
		default:
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields.
-(void)displayComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = (id)self;
	
	[picker setSubject:@"Доставка 33"];
	
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@""];
	NSArray *ccRecipients = [NSArray arrayWithObjects:@"", nil];
	NSArray *bccRecipients = [NSArray arrayWithObject:@""];
	
	[picker setToRecipients:toRecipients];
	[picker setCcRecipients:ccRecipients];
	[picker setBccRecipients:bccRecipients];
	
	// Attach an image to the email
	//NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
    //NSData *myData = [NSData dataWithContentsOfFile:path];
	//[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
	
	// Fill out the email body text
	NSString *emailBody = @"I downloaded \"Доставка 33\" from AppStore and I like it! :) \n https://itunes.apple.com/us/app/dostavka-33/id571980030?ls=1&mt=8";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	//message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Result: canceled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Result: saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Result: sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Result: failed");
			break;
		default:
			NSLog(@"Result: not sent");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
	NSString *body = @"&body=It is raining in sunny California!";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}



@end
