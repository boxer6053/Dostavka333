#import "FacebookShareViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookShareViewController () <UITextViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *postMessageTextView;
@property (strong, nonatomic) IBOutlet UIImageView *postImageView;
@property (strong, nonatomic) IBOutlet UILabel *postName;
@property (strong, nonatomic) IBOutlet UILabel *postProductInfo;
@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *imageConnection;

- (IBAction)share:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@implementation FacebookShareViewController
@synthesize postParams = _postParams;
@synthesize imageData = _imageData;
@synthesize imageConnection = _imageConnection;
@synthesize name = _name;
@synthesize imageLink = _imageLink;
@synthesize info = _info;


NSString *const kPlaceholderPostMessage = @"Say something about this product...";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
    }

- (void)resetPostMessage
{
    self.postMessageTextView.text = kPlaceholderPostMessage;
    self.postMessageTextView.textColor = [UIColor lightGrayColor];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:kPlaceholderPostMessage]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        [self resetPostMessage];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.postMessageTextView isFirstResponder] &&
        (self.postMessageTextView != touch.view))
    {
        [self.postMessageTextView resignFirstResponder];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     _imageLink, @"pictureOfProduct",
     _name, @"nameOfProduct",
     _info, @"infoAboutProduct",
     nil];

    
    [self resetPostMessage];
    self.postName.text = [_postParams objectForKey:@"nameOfProduct"];
    self.postProductInfo.text = [_postParams
                                      objectForKey:@"infoAboutProduct"];
    [self.postProductInfo sizeToFit];
    

    _imageData = [[NSMutableData alloc] init];
    NSURLRequest *imageRequest = [NSURLRequest
                                  requestWithURL:
                                  [NSURL URLWithString:
                                   [_postParams objectForKey:@"pictureOfProduct"]]];
    _imageConnection = [[NSURLConnection alloc] initWithRequest:
                            imageRequest delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    if (_imageConnection) {
        [_imageConnection cancel];
        _imageConnection = nil;
    }

    [super viewDidUnload];
}
- (IBAction)share:(id)sender {
    if ([self.postMessageTextView isFirstResponder]) {
        [self.postMessageTextView resignFirstResponder];
    }
    if (![self.postMessageTextView.text
          isEqualToString:kPlaceholderPostMessage] &&
        ![self.postMessageTextView.text isEqualToString:@""]) {
        [_postParams setObject:self.postMessageTextView.text
                            forKey:@"message"];
    }
    
    // Ask for publish_actions permissions in context
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // No permissions found in session, ask for it
        [FBSession.activeSession
         reauthorizeWithPublishPermissions:
         [NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceFriends
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 // If permissions granted, publish the story
                 [self publishStory];
             }
         }];
    } else {
        // If permissions present, publish the story
        [self publishStory];
    }
}

//// image ////
- (void)connection:(NSURLConnection*)connection
    didReceiveData:(NSData*)data{
    [_imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    // Load the image
    self.postImageView.image = [UIImage imageWithData:
                                [NSData dataWithData:_imageData]];
    _imageConnection = nil;
    _imageData = nil;
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error{
    _imageConnection = nil;
    _imageData = nil;
}
///////end image/////

- (void)publishStory
{
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:_postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          [result objectForKey:@"id"]];
         }
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
     }];
}

- (void) alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[self presentingViewController]
     dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
    [[self presentingViewController]
     dismissModalViewControllerAnimated:YES];
}
@end
