//
//  ViewController.m
//  oauthio
//
//  Copyright (c) 2013 Webshell. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_activityIndicator setHidden:YES];
    [_buttonTwitter setTag:kTWITTER_BUTTON];
    [_buttonFacebook setTag:kFACEBOOK_BUTTON];
    [_buttonGooglePlus setTag:kGOOGLE_PLUS_BUTTON];
    [_buttonLinkedIn setTag:kLINKED_IN_BUTTON];
    
    _oauthioModal = [[OAuthIOModal alloc] initWithKey:@"WmKGOEutadU6jZ8agshVaz1VMiM" delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_oauthioModal release];
    [_activityIndicator release];
    [_buttonTwitter release];
    [_buttonFacebook release];
    [_buttonGooglePlus release];
    [_buttonLinkedIn release];
    
    [super dealloc];
}

- (IBAction)connect:(id)sender
{
    [_buttonTwitter setHidden:YES];
    [_buttonFacebook setHidden:YES];
    [_buttonGooglePlus setHidden:YES];
    [_buttonLinkedIn setHidden:YES];
    [_activityIndicator setHidden:NO];
    [_activityIndicator startAnimating];
    
    NSUInteger button_id = ((UIButton *)sender).tag;
    NSString *provider = nil;
    
    if (button_id == kTWITTER_BUTTON)
        provider = @"twitter";
    else if (button_id == kFACEBOOK_BUTTON)
        provider = @"facebook";
    else if (button_id == kGOOGLE_PLUS_BUTTON)
        provider = @"google_plus";
    else if (button_id == kLINKED_IN_BUTTON)
        provider = @"linkedin";
    
    [_oauthioModal showWithProvider:provider];
}

- (void) hideActivityIndicator
{
    [_activityIndicator startAnimating];
    [_activityIndicator setHidden:YES];
    [_buttonTwitter setHidden:NO];
    [_buttonFacebook setHidden:NO];
    [_buttonGooglePlus setHidden:NO];
    [_buttonLinkedIn setHidden:NO];
}

#pragma mark OAuthIO delegate methods

- (void)didReceiveOAuthIOResponse:(NSDictionary *)result
{
    [self hideActivityIndicator];
    
    NSLog(@"\nRESULT:\n-------\n%@\n", result);
}

- (void)didFailWithOAuthIOError:(NSError *)error
{
    [self hideActivityIndicator];
    
    NSLog(@"\nERROR:\n--------\n%@\n", error.description);
}

@end
