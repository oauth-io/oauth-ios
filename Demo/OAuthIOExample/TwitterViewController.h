//
//  FirstViewController.m
//  OAuthIOExample
//

#import <Foundation/Foundation.h>
#import "OAuthIORequest.h"

@interface TwitterViewController : UIViewController<UITableViewDelegate, UIAlertViewDelegate, UIToolbarDelegate>
{
@private
    NSArray *_outputArr;
}

@property (nonatomic, strong) OAuthIORequest *request;
@property (strong, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (strong, nonatomic) IBOutlet UIToolbar *twitterToolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addTweetBtn;

- (IBAction)refreshEvent:(id)sender;
- (IBAction)addTweetEvent:(id)sender;

@end
