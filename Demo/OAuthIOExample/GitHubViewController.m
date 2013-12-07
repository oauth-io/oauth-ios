//
//  FirstViewController.m
//  OAuthIOExample
//


#import "GitHubViewController.h"

@interface GitHubViewController ()

@end

@implementation GitHubViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [_githubToolbar setItems:[NSArray arrayWithObjects:_githubRefreshBtn, flexibleSpaceLeft, _githubAddBtn, nil]];
    
    [_request get:@"/user" withParams:nil success:^(NSString *output, NSHTTPURLResponse *httpResponse) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[output dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        _login = [dict objectForKey:@"login"];

        if (_login)
            [self getRepos];
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getRepos
{
    NSString *url = [NSString stringWithFormat:@"/users/%@/repos", _login];
    [_request get:url withParams:nil success:^(NSString *output, NSHTTPURLResponse *httpResponse)
    {
        if (httpResponse.statusCode == 200)
        {
            _outputArr = [NSJSONSerialization JSONObjectWithData:[output dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
            [_githubTableView reloadData];
        }
        
    }];

}

#pragma mark - Events
- (IBAction)resfreshRepo:(id)sender
{
    [self getRepos];
}

- (IBAction)addRepo:(id)sender
{
    UIAlertView *addRepoView = [[UIAlertView alloc] initWithTitle:@"Add a new Repo !" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [addRepoView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [addRepoView show];
}

#pragma mark - UIAlerView delegate method
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (_login)
        {
            NSDictionary *params = @{@"name": [[alertView textFieldAtIndex:0] text]};
            
            [_request setContentType:@"json"]; // Github specification - This line convert params to JSON
            [_request post:@"/user/repos" withParams:params success:^(NSString *output, NSHTTPURLResponse *httpResponse) {
                [self getRepos];
            }];
        }
    }
}

#pragma mark - UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([_outputArr count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"tweetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    
    if (_outputArr)
    {
        NSDictionary *dict = [_outputArr objectAtIndex:indexPath.row];
        
        if (dict)
        {
            cell.textLabel.font = [UIFont fontWithName:cell.textLabel.font.fontName size:9.0];
            cell.detailTextLabel.font = [UIFont fontWithName:cell.textLabel.font.fontName size:8.0];
            cell.textLabel.text = [dict objectForKey:@"name"];
            cell.detailTextLabel.text = [dict objectForKey:@"created_at"];
        }
    }
    
    return (cell);
}


@end
