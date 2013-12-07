//
//  FirstViewController.m
//  OAuthIOExample
//


#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _oauthio = [[OAuthIOModal alloc] initWithKey:@"WmKGOEutadU6jZ8agshVaz1VMiM" delegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectEvent:(id)sender
{
    _buttonTag = [sender tag];
    
    if (_buttonTag == kTWITTER_BTN)
    {
        if (_req_twitter == nil)
        {
            [_oauthio showWithProvider:@"twitter"];
        }
        else
        {
            _twitterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TwitterViewController"];
            _twitterViewController.request = _req_twitter;
            [self.navigationController pushViewController:_twitterViewController animated:YES];
        }
    }
    else
    {
        if (_req_github == nil)
        {
            [_oauthio showWithProvider:@"github"];
        }
        else
        {
            _githubViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GithubViewController"];
            _githubViewController.request = _req_github;
            [self.navigationController pushViewController:_githubViewController animated:YES];
        }
    }
}

#pragma mark - OAuthIO delegate methods

- (void)didReceiveOAuthIOResponse:(OAuthIORequest *)request
{
    if (_buttonTag == kTWITTER_BTN)
    {
        _req_twitter = [request copy];
        _twitterViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TwitterViewController"];
        _twitterViewController.request = _req_twitter;
        [self.navigationController pushViewController:_twitterViewController animated:YES];
    }
    else
    {
        _req_github = [request copy];
        _githubViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GithubViewController"];
        _githubViewController.request = _req_github;
        [self.navigationController pushViewController:_githubViewController animated:YES];
    }
}

- (void)didFailWithOAuthIOError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
