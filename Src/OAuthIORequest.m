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
    return ([(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, nil, CFSTR("&?=+/:"), kCFStringEncodingUTF8) autorelease]);
}

+ (NSString *)decodeURL:(NSString *)str
{
    return ([(NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)str, CFSTR(""), kCFStringEncodingUTF8) autorelease]);
}

- (NSString *)buildQueryWithDictionnary:(NSDictionary *)params
{
    NSString *query = [[[NSString alloc] init] autorelease];
    NSUInteger i = 1;
    
    for (NSString *key in [params allKeys])
    {
        if ([key length] != 0 && ![key isEqualToString:@"p"])
        {
            if (i == 1)
                query = [query stringByAppendingFormat:@"?%@=%@", key, [params objectForKey:key]];
            else
                query = [query stringByAppendingFormat:@"&%@=%@", key, [params objectForKey:key]];
         
            i++;
        }
    }

    return (query);
}

- (id)initWithBaseUrl:(NSString *)baseUrl
{
    self = [super init];
    
    if (!self)
        return nil;
    
    _baseUrl = baseUrl;
    
    return (self);
}

- (void)requestWithParams:(NSDictionary *)params success:(RequestSuccessBlock)success error:(RequestErrorBlock)error
{
    _success = [success copy];
    _error = [error copy];
    
    NSString *query = [self buildQueryWithDictionnary:params];
    NSString *url = [[[NSString alloc] initWithFormat:@"%@/%@%@", _baseUrl, [params objectForKey:@"p"], query] autorelease];
    
    _req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_req setValue:@"(iPhone; iPad) AppleWebKit" forHTTPHeaderField:@"User-Agent"];
    _connection = [[NSURLConnection alloc] initWithRequest:_req delegate:self];
    
    [_connection start];
    [_connection release];
}


#pragma mark NSURLConnexion delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
    _request = [(NSURLRequest *)response copy];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _success(_responseData, _request);
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return (nil);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _error(error);
}


@end
