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

- (NSURLRequest *)getOAuthRequest:(NSString *)provider
                      andUrl:(NSString *)url
                  andOptions:(NSDictionary*)options
{
    NSString *optionString = options? [NSString stringWithFormat:@"&opts=%@",[OAuthIO dictionaryToJSON:options]]
            : @"";
    
    NSString *queryString = [[NSString alloc] initWithFormat:@"%@/%@?k=%@%@&redirect_uri=%@&mobile=true", [NSString stringWithFormat:@"%@/auth", kOAUTHIO_URL], provider, _key, optionString, url];
    
    _req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:queryString]];
    [_req setValue:@"(iPhone; iPad) AppleWebKit" forHTTPHeaderField:@"User-Agent"];
    return _req;
}

+(NSString*)dictionaryToJSON:(NSDictionary*)dictionary {
    NSMutableString *retval = [@"{" mutableCopy];
    for (NSString *key in [dictionary allKeys]) {
        NSString *value = dictionary[key];
        [retval appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",", key, value]];
    }
    [retval replaceCharactersInRange:NSMakeRange([retval length]-1, 1) withString:@"}"];
    return [OAuthIORequest encodeURL:retval];
}

@end
