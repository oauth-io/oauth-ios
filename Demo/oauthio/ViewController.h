//
//  ViewController.h
//  oauthio
//
//  Copyright (c) 2013 Webshell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthIOModal.h"

#define kTWITTER_BUTTON     1
#define kFACEBOOK_BUTTON    2
#define kGOOGLE_PLUS_BUTTON 3
#define kLINKED_IN_BUTTON   4

@interface ViewController : UIViewController<OAuthIODelegate>

@property (nonatomic, retain) OAuthIOModal *oauthioModal;
@property (retain, nonatomic) IBOutlet UIButton *buttonTwitter;
@property (retain, nonatomic) IBOutlet UIButton *buttonFacebook;
@property (retain, nonatomic) IBOutlet UIButton *buttonGooglePlus;
@property (retain, nonatomic) IBOutlet UIButton *buttonLinkedIn;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)connect:(id)sender;

@end
