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

#import "OAuthIORequest.h"

@implementation OAuthIORequest

+ (NSString *)encodeURL:(NSString *)str
{
    static NSString * const charactersToEscaped = @":/?&;+!@#$()~',*";
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, nil, (__bridge CFStringRef)charactersToEscaped, kCFStringEncodingUTF8));
}

+ (NSString *)decodeURL:(NSString *)str
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), kCFStringEncodingUTF8));
}

- (id)initWithOAuthIOData:(OAuthIOData *)data
{
    self = [super init];
        if (!self)

        return (nil);

    _data = data;
    
    return (self);
}

- (id)copyWithZone:(NSZone *)zone
{
    OAuthIORequest *request = [[OAuthIORequest allocWithZone:zone] initWithOAuthIOData:_data];

    return (request);
}

- (void)prepareAndExec:(NSString *)resource andMethod:(NSString *)method andParams:(id)params
{
    if (_data.oauth_token != nil && _data.oauth_token_secret != nil)
    {
        NSMutableString *resxUrl = [NSMutableString stringWithString:resource];
        
        if ([resxUrl characterAtIndex:0] != (int)'/')
            [resxUrl insertString:@"/" atIndex:0];

        NSString *oauthio_header = [NSString stringWithFormat:@"k=%@&oauthv=1&oauth_token=%@&oauth_token_secret=%@", [OAuthIO getPublicKey], _data.oauth_token, _data.oauth_token_secret];
        
        NSMutableString *url = [NSMutableString stringWithFormat:@"%@/request/%@%@", kOAUTHIO_URL, _data.provider, resxUrl];

        if (_data.request_query)
        {
            if ([method isEqualToString:kOAUTHIO_GET_METHOD] && params)
                [url appendFormat:@"?%@%@", [self buildQueryWithDictionnary:_data.request_query], [self buildQueryWithDictionnary:params]];
            else
                [url appendFormat:@"?%@", [self buildQueryWithDictionnary:_data.request_query]];

        }
        else if ([method isEqualToString:kOAUTHIO_GET_METHOD] && params)
            [url appendFormat:@"?%@", [self buildQueryWithDictionnary:params]];
        
        //url = [NSMutableString stringWithString:@"http://httpbin.org/post"];
        _req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_req setValue:oauthio_header forHTTPHeaderField:@"oauthio"];
        [_req setHTTPMethod:method];
        
        if ([_headers count] && _headers != nil)
            for (NSString *key in [_headers allKeys])
                [_req setValue:[_headers objectForKey:key] forHTTPHeaderField:key];
        
        if ([method isEqualToString:kOAUTHIO_POST_METHOD] || [method isEqualToString:kOAUTHIO_PUT_METHOD] || [method isEqualToString:kOAUTHIO_PATCH_METHOD])
        {
            NSData *postData = [self buildPostParams:params];
            if (postData != nil)
                [_req setHTTPBody:postData];
        }
        
        _connection = [[NSURLConnection alloc] initWithRequest:_req delegate:self];
        [_connection start];
    }
    else if (_data.oauth_token != nil)
    {
        if (!_data.request)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The provider does have an API request description"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        NSMutableString *resxUrl = [NSMutableString stringWithString:resource];

        if ([resxUrl characterAtIndex:0] != (int)'/')
            [resxUrl insertString:@"/" atIndex:0];

        NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"%@%@", [self replaceParam:_data.request_url values:_data.request], resxUrl];

        if (_data.request_query)
        {
            if ([method isEqualToString:kOAUTHIO_GET_METHOD] && params)
                [url appendFormat:@"?%@%@", [self buildQueryWithDictionnary:_data.request_query], [self buildQueryWithDictionnary:params]];
            else
                [url appendFormat:@"?%@", [self buildQueryWithDictionnary:_data.request_query]];
            
        }
        else if ([method isEqualToString:kOAUTHIO_GET_METHOD] && params)
            [url appendFormat:@"?%@", [self buildQueryWithDictionnary:params]];

        _req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_req setHTTPMethod:method];
        
        if (_data.request_headers)
            [self buildHeaderWithDictionnary:_data.request_headers];

        if ([_headers count] && _headers != nil)
            for (NSString *key in [_headers allKeys])
                [_req setValue:[_headers objectForKey:key] forHTTPHeaderField:key];
        
        if ([method isEqualToString:kOAUTHIO_POST_METHOD] || [method isEqualToString:kOAUTHIO_PUT_METHOD] || [method isEqualToString:kOAUTHIO_PATCH_METHOD])
        {
            NSData *postData = [self buildPostParams:params];
            
            if (postData != nil)
                [_req setHTTPBody:postData];
        }
        
        _connection = [[NSURLConnection alloc] initWithRequest:_req delegate:self];
        [_connection start];
    }
}

- (void)get:(NSString *)resource withParams:(id)params success:(RequestSuccessBlock)success
{
    _success = [success copy];
    [self prepareAndExec:resource andMethod:kOAUTHIO_GET_METHOD andParams:params];
}

- (void)post:(NSString *)resource withParams:(id)params success:(RequestSuccessBlock)success
{
    _success = [success copy];
    [self prepareAndExec:resource andMethod:kOAUTHIO_POST_METHOD andParams:params];
}

- (void)put:(NSString *)resource withParams:(id)params success:(RequestSuccessBlock)success
{
    _success = [success copy];
    [self prepareAndExec:resource andMethod:kOAUTHIO_PUT_METHOD andParams:params];
}

- (void)patch:(NSString *)resource withParams:(id)params success:(RequestSuccessBlock)success
{
    _success = [success copy];
    [self prepareAndExec:resource andMethod:kOAUTHIO_PATCH_METHOD andParams:params];
}

- (void)delete:(NSString *)resource success:(RequestSuccessBlock)success
{
    _success = [success copy];
    [self prepareAndExec:resource andMethod:kOAUTHIO_DELETE_METHOD andParams:nil];
}

- (void)addHeaderWithKey:(NSString *)key andValue:(NSString *)value
{
    if (!_headers)
        _headers = [[NSMutableDictionary alloc] init];
    
    [_headers setValue:value forKey:key];
}

- (NSString *)replaceParam:(NSString *)key values:(NSDictionary *)dict
{
    if (![key rangeOfString:@"{"].length)
        return (key);
    
    __block NSString *ret = nil;
    __block NSRange         range;
    
    NSRegularExpression     *regex = nil;
    NSError *error = nil;
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\{\\{.*?\\}\\}" options:NSRegularExpressionCaseInsensitive error:&error];
    [regex enumerateMatchesInString:key options:0 range:NSMakeRange(0, [key length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop)
    {
        range = NSMakeRange(match.range.location + 2, match.range.length - 4);
        NSString *value = [dict objectForKey:[key substringWithRange:range]];
        ret = [regex stringByReplacingMatchesInString:key options:0 range:NSMakeRange(0, [key length]) withTemplate:value];
    }];
    
    if (ret)
        return (ret);
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\{.*?\\}" options:NSRegularExpressionCaseInsensitive error:&error];
    [regex enumerateMatchesInString:key options:0 range:NSMakeRange(0, [key length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop)
    {
        range = NSMakeRange(match.range.location + 1, match.range.length - 2);
        NSString *value = [_data.request_parameters valueForKey:[key substringWithRange:range]];
        ret = [regex stringByReplacingMatchesInString:key options:0 range:NSMakeRange(0, [key length]) withTemplate:value];
    }];
    
    return (ret);
}

- (NSString *)buildQueryWithDictionnary:(NSDictionary *)params
{
    NSString *query = [[NSString alloc] init];
    NSUInteger i = 1;
    
    for (NSString *key in [params allKeys])
    {
        if ([key length] != 0)
        {
            NSString *val = [params objectForKey:key];
            
            if ([val length] != 0)
            {
                val = [self replaceParam:val values:_data.request];
                
                if (i == 1)
                    query = [query stringByAppendingFormat:@"%@=%@", key, val];
                else
                    query = [query stringByAppendingFormat:@"&%@=%@", key, val];
                
            }
            
            i++;
        }
    }
    
    return (query);
}

- (NSString *)buildHeaderWithDictionnary:(NSDictionary *)params
{
    NSString *query = [[NSString alloc] init];

    for (NSString *key in [params allKeys])
    {
        if ([key length] != 0)
        {
            NSString *val = [params objectForKey:key];
            
            if ([val length] != 0)
            {
                val = [self replaceParam:val values:_data.request];
                [_req setValue:val forHTTPHeaderField:key];
            }
        }
    }
    
    return (query);
}

- (NSData *)buildPostParams:(id)params
{
    NSData *postData = nil;
    if ([params isKindOfClass:[NSDictionary class]])
    {
        if (_contentType != nil)
            postData = [[self formatFromContentType:params] dataUsingEncoding:NSUTF8StringEncoding];
        else
            postData = [[OAuthIORequest encodeURL:[self buildQueryWithDictionnary:params]] dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ([params isKindOfClass:[NSString class]])
        postData = [params dataUsingEncoding:NSUTF8StringEncoding];
    else if ([params isKindOfClass:[NSData class]])
        postData = params;
    
    NSString *contentLength = [NSString stringWithFormat:@"%i", [postData length]];
    [self addHeaderWithKey:@"Content-Length" andValue:contentLength];

    return (postData);
}

- (NSString *)formatFromContentType:(NSDictionary *)params
{
    if ([[_contentType lowercaseString] isEqualToString:@"application/json"] || [[_contentType lowercaseString] isEqualToString:@"json"])
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
        NSString *json = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        [self addHeaderWithKey:@"Content-Type" andValue:@"application/json"];
        
        return (json);
    }
    
    return (nil);
}

#pragma mark NSURLConnexion delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
    _response = [response copy];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _headers = nil;
     NSString *output = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    _success(output, _response);
 
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return (nil);
}

@end
