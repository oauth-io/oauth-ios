//
//  FirstViewController.h
//  OAuthIOExample
//

#import <UIKit/UIKit.h>
#import "OAuthIOModal.h"
#import "TwitterViewController.h"
#import "GitHubViewController.h"

#define kTWITTER_BTN 1
#define kGITHUB_BTN  2

@interface FirstViewController : UIViewController<OAuthIODelegate>
{
@private
    NSInteger _buttonTag;
}

@property (nonatomic, retain) OAuthIOModal            *oauthio;

@property (nonatomic, retain) TwitterViewController   *twitterViewController;
@property (nonatomic, retain) OAuthIORequest          *req_twitter;

@property (nonatomic, retain) GitHubViewController    *githubViewController;
@property (nonatomic, retain) OAuthIORequest          *req_github;


@property (strong, nonatomic) IBOutlet UIButton *connectGithubBtn;
@property (strong, nonatomic) IBOutlet UIButton *connectTwitterBtn;

- (IBAction)connectEvent:(id)sender;

@end
