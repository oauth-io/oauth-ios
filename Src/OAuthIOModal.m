/*
 * (C) Copyright 2013 Webshell SAS.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "OAuthIOModal.h"

@implementation OAuthIOModal

NSString *_host;

+ (void) handleOAuthIOResponse:(NSURL *)url
{
    if ([url.host isEqualToString:_host])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OAuthIOGetTokens" object:self userInfo:[NSDictionary dictionaryWithObject:url forKey:@"URL"]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return (self);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_browser setFrame:CGRectMake(0, _navigationBarHeight, _browser.frame.size.width, _browser.frame.size.height - _navigationBarHeight - 1)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTokens:) name:@"OAuthIOGetTokens" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithKey:(NSString *)key delegate:(id)delegate
{
    self = [super init];
    
    if (!self || ![self initCustomCallbackURL])
        return (nil);
    
    [self setDelegate:delegate];
    
    _key = key;
    _oauth = [[OAuthIO alloc] initWithKey:_key];
    _rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        _navigationBarHeight = NAVIGATION_BAR_HEIGHT_IOS7_OR_LATER;
    else
        _navigationBarHeight = NAVIGATION_BAR_HEIGHT_IOS6_OR_EARLIER;
    
    [self initNavigationBar];

    return (self);
}

- (void)getTokens:(NSNotification *)notification
{
    NSString *url = [OAuthIORequest decodeURL:[NSString stringWithFormat:@"%@", [notification.userInfo objectForKey:@"URL"]]];
    NSUInteger start_pos = [url rangeOfString:@"="].location + 1;
    NSString *json = [url substringWithRange:NSMakeRange(start_pos, [url length] - start_pos)];
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
   
    if (jsonData)
    {
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
       
        if (error)
        {
            if ([self.delegate respondsToSelector:@selector(didFailWithOAuthIOError:)])
                [self.delegate didFailWithOAuthIOError:error];

            return;
        }
        
        _oauthio_data = [[OAuthIOData alloc] initWithDictionary:jsonDict];
        _request = [[OAuthIORequest alloc] initWithOAuthIOData:_oauthio_data];
       
        if ([self.delegate respondsToSelector:@selector(didReceiveOAuthIOResponse:)])
            [self.delegate didReceiveOAuthIOResponse:_request];
    }
}


# pragma mark - Toolbar methods

- (void)initNavigationBar
{
    _navigationBar = [[UINavigationBar alloc] init];
    [_navigationBar setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:nil action:@selector(cancelOperation)];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:nil action:@selector(refreshOperation)];
    
    [navItem setRightBarButtonItem:cancelButton];
    [navItem setLeftBarButtonItem:refreshButton];
    
    [_navigationBar pushNavigationItem:navItem animated:NO];
    
    [self drawNavigationBar];
}

- (void)drawNavigationBar
{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    [_navigationBar setFrame:CGRectMake(0, 0, width, _navigationBarHeight)];
    [self.view addSubview:_navigationBar];
}

- (void)refreshOperation
{
    [_browser reload];
}

- (void)cancelOperation
{
    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:@"Operation canceled" forKey:NSLocalizedDescriptionKey];
    NSError *error = [[NSError alloc] initWithDomain:@"OAuthIO" code:100 userInfo:errorDetail];
    
    if ([self.delegate respondsToSelector:@selector(didFailWithOAuthIOError:)])
        [self.delegate didFailWithOAuthIOError:error];    

    [_browser loadHTMLString:nil baseURL:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)initCustomCallbackURL
{
    NSDictionary *customURLDict = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"] objectAtIndex:0];
    
    if (customURLDict)
    {
        _scheme = [[customURLDict objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
        _host = [customURLDict objectForKey:@"CFBundleURLName"];
    }
    
    if (_scheme && _host)
        _callback_url = [[NSString alloc] initWithFormat:@"%@://%@", _scheme, _host];
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OAuthIO" message:@"You must define a custom scheme and an url identifier in your plist configuration file" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return (NO);
    }
    
    return (YES);

}

- (void)showWithProvider:(NSString *)provider
{
    [_oauth redirectWithProvider:provider andUrl:_callback_url success:^(NSData *data, NSHTTPURLResponse *httpResponse){
        
        [_rootViewController presentViewController:self animated:YES completion:^{
            
            [_browser loadData:data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:httpResponse.URL];
            
        }];
        
    } error:^(NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(didFailWithOAuthIOError:)])
            [self.delegate didFailWithOAuthIOError:error];
    }];
}

#pragma mark - UIWebView delegate method

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"] && ![url.scheme isEqual:@"file"])
    {
        if ([[UIApplication sharedApplication]canOpenURL:url])
        {
            [[UIApplication sharedApplication]openURL:url];
            
            if ([request.URL.host isEqualToString:_host])
                [self dismissViewControllerAnimated:YES completion:nil];

            return (NO);
        } 
    }
    
    return (YES);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999)
        return;
    
    if ([self.delegate respondsToSelector:@selector(didFailWithOAuthIOError:)])
        [self.delegate didFailWithOAuthIOError:error];
}

@end
