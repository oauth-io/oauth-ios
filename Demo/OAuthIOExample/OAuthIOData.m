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

#import "OAuthIOData.h"

@implementation OAuthIOData

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if (!self || !dict)
        return (nil);
    
    _request = [[NSMutableDictionary alloc] init];
    
    if ([[dict objectForKey:@"data"] objectForKey:@"access_token"] != nil)
    {
        _oauth_token = [[dict objectForKey:@"data"] objectForKey:@"access_token"];
        [_request setValue:_oauth_token forKey:@"token"];
    }
    else if ([[dict objectForKey:@"data"] objectForKey:@"oauth_token"] != nil && [[dict objectForKey:@"data"] objectForKey:@"oauth_token_secret"] != nil)
    {
        _oauth_token = [[dict objectForKey:@"data"] objectForKey:@"oauth_token"];
        _oauth_token_secret = [[dict objectForKey:@"data"] objectForKey:@"oauth_token_secret"];
        
        [_request setValue:_oauth_token forKey:@"oauth_token"];
        [_request setValue:_oauth_token_secret forKey:@"oauth_token_secret"];
    }
    
    _request_conf = [[dict objectForKey:@"data"] objectForKey:@"request"];
    _request_url = [_request_conf objectForKey:@"url"];
    _request_headers = [_request_conf objectForKey:@"headers"];
    _request_parameters = [_request_conf objectForKey:@"parameters"];
    _request_query = [_request_conf objectForKey:@"query"];
    _provider = [dict objectForKey:@"provider"];

    for (NSString *key in [[dict objectForKey:@"data"] allKeys])
    {
        if (![key isKindOfClass:[NSDictionary class]] || ![key isKindOfClass:[NSArray class]])
            [_request setValue:[[dict objectForKey:@"data"] valueForKey:key] forKey:key];
    }
    
    for (NSString *key in [[_request_conf objectForKey:@"parameters"] allKeys])
    {
        if (![key isKindOfClass:[NSDictionary class]] || ![key isKindOfClass:[NSArray class]])
            [_request setValue:[[_request_conf objectForKey:@"parameters"] valueForKey:key] forKey:key];
    }

    return (self);
}

@end
