//
//  FirstViewController.m
//  OAuthIOExample
//

#import <UIKit/UIKit.h>
#import "OAuthIORequest.h"

@interface GitHubViewController : UIViewController<UITableViewDelegate, UIAlertViewDelegate>
{
@private
    NSString    *_login;
    NSArray     *_outputArr;
}
@property (nonatomic, strong) OAuthIORequest            *request;
@property (strong, nonatomic) IBOutlet UITableView      *githubTableView;
@property (strong, nonatomic) IBOutlet UIToolbar        *githubToolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem  *githubRefreshBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem  *githubAddBtn;


- (IBAction)resfreshRepo:(id)sender;
- (IBAction)addRepo:(id)sender;

@end
