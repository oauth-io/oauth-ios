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

#import <UIKit/UIKit.h>
#import "OAuthIORequest.h"
#import "OAuthIO.h"

#define NAVIGATION_BAR_HEIGHT_IOS7_OR_LATER     64
#define NAVIGATION_BAR_HEIGHT_IOS6_OR_EARLIER   44

@protocol OAuthIODelegate <NSObject>
- (void)didReceiveOAuthIOResponse:(OAuthIORequest *)request;
- (void)didFailWithOAuthIOError:(NSError *)error;
- (void)didReceiveOAuthIOCode:(NSString *)code;
- (void)didAuthenticateServerSide:(NSString *)body andResponse:(NSURLResponse *) response;
- (void)didFailAuthenticationServerSide:(NSString *)body andResponse:(NSURLResponse *)response andError:(NSError *)error;
@end

@interface OAuthIOModal : UIViewController<UIWebViewDelegate>
{

@private
    NSDictionary        *_options;
    OAuthIO             *_oauth;
    OAuthIOData         *_oauthio_data;
    OAuthIORequest      *_request;

    NSString            *_key;
    NSString            *_scheme;
    NSString            *_callback_url;
    UIViewController    *_rootViewController;
    UIWebView           *_browser;	
    UINavigationBar     *_navigationBar;
    NSUInteger          _navigationBarHeight;
    

}
@property NSMutableArray *saved_cookies;
@property (weak) id<OAuthIODelegate>   delegate;
@property NSURLSession *session;
@property NSString *authUrl;

- (id)initWithKey:(NSString *)key delegate:(id)delegate;
- (id)initWithKey:(NSString *)key delegate:(id)delegate andOptions:(NSDictionary *) options;
- (void)showWithProvider:(NSString *)provider;
- (void)showWithProvider:(NSString *)provider options:(NSDictionary*)options;
- (void)showWithProvider:(NSString *)provider options:(NSDictionary*)options stateTokenUrl:(NSString*) stateUrl authUrl:(NSString*) authUrl;
- (BOOL) clearCache;
- (BOOL) clearCacheForProvider:(NSString *)provider;
- (BOOL) cacheAvailableForProvider:(NSString *)provider;

@end
