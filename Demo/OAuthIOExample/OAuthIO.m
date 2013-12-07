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

#import "OAuthIO.h"

@implementation OAuthIO

NSString *_key;

+ (NSString *)getPublicKey
{
    return (_key);
}

- (id)initWithKey:(NSString *)key
{
    self  = [super init];
    
    if (!self)
        return nil;
    
    _key = key;
    
    return (self);
}

- (void)redirectWithProvider:(NSString *)provider andUrl:(NSString *)url success:(OAuthIOSuccessBlock)success error:(OAuthIOErrorBlock)error
{
    _success = [success copy];
    _error = [error copy];
    
    NSString *queryString = [[NSString alloc] initWithFormat:@"%@/%@?k=%@&redirect_uri=%@", [NSString stringWithFormat:@"%@/auth", kOAUTHIO_URL], provider, _key, url];
    
    _req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:queryString]];
    [_req setValue:@"(iPhone; iPad) AppleWebKit" forHTTPHeaderField:@"User-Agent"];
    _connection = [[NSURLConnection alloc] initWithRequest:_req delegate:self];
    [_connection start];
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
    _success(_responseData, _response);
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
