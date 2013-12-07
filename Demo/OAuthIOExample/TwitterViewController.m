//
//  FirstViewController.m
//  OAuthIOExample
//


#import "TwitterViewController.h"

@implementation TwitterViewController

- (void)viewDidLoad
{
    // Add tweet button to the right...
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [_twitterToolbar setItems:[NSArray arrayWithObjects:_refreshBtn, flexibleSpaceLeft, _addTweetBtn, nil]];
    [self getTweets];
}

- (void)getTweets
{
    [_request get:@"/1.1/statuses/home_timeline.json" withParams:nil success:^(NSString *output, NSHTTPURLResponse *httpResponse)
     {
         if (httpResponse.statusCode == 200)
         {
             _outputArr = [NSJSONSerialization JSONObjectWithData:[output dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
             [_tweetsTableView reloadData];
         }
     }];
}

- (void)refreshEvent:(id)sender
{
    [self getTweets];
}

- (IBAction)addTweetEvent:(id)sender
{
    UIAlertView *addTweetView = [[UIAlertView alloc] initWithTitle:@"New Teweet !" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [addTweetView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [addTweetView show];
    
}


#pragma mark - UIAlerView delegate method

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
        if (buttonIndex == 1)
        {
            NSDictionary *params = @{@"status": [[alertView textFieldAtIndex:0] text]};
            
            [_request post:@"/1.1/statuses/update.json" withParams:params success:^(NSString *output, NSHTTPURLResponse *httpResponse) {
                NSLog(@"add Tweet repsonse code : %i\n", httpResponse.statusCode);
                [self getTweets];
            }];
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
            cell.textLabel.text = [dict objectForKey:@"text"];
            cell.detailTextLabel.text = [dict objectForKey:@"created_at"];
        }
    }

    return (cell);
}


@end
