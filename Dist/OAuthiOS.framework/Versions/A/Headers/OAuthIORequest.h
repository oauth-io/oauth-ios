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

#import <Foundation/Foundation.h>
#include "OAuthIOData.h"
#include "OAuthIO.h"

#define kOAUTHIO_URL @"https://oauth.io"

#define kOAUTHIO_GET_METHOD     @"GET"
#define kOAUTHIO_POST_METHOD    @"POST"
#define kOAUTHIO_PUT_METHOD     @"PUT"
#define kOAUTHIO_PATCH_METHOD   @"PATCH"
#define kOAUTHIO_DELETE_METHOD  @"DELETE"

typedef void (^RequestSuccessBlock) (NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse);
typedef void (^RequestErrorBlock) (NSError *error);

@interface OAuthIORequest : NSObject<NSURLConnectionDelegate, NSCopying>
{
@private
    NSURLConnection     *_connection;
    NSHTTPURLResponse   *_response;
    NSMutableURLRequest *_req;
    NSMutableData       *_responseData;
    NSMutableDictionary *_headers;
}

@property (nonatomic, copy)     RequestSuccessBlock success;
@property (nonatomic, copy)     RequestErrorBlock   error;
@property (nonatomic, strong)   OAuthIOData         *data;
@property (nonatomic, strong)   NSString            *contentType;


+ (NSString *)encodeURL:(NSString *)str;
+ (NSString*)decodeURL:(NSString *)str;

- (id)initWithOAuthIOData:(OAuthIOData *)data;
- (id)copyWithZone:(NSZone *)zone;
- (NSDictionary *)getCredentials;

- (void)addHeaderWithKey:(NSString *)key andValue:(NSString *)value;
- (void)get:(NSString *)resource success:(RequestSuccessBlock)success;
- (void)get:(NSString *)resource withParams:(id)params success:(RequestSuccessBlock)success;
- (void)post:(NSString *)resource withParams:(id)params success:(RequestSuccessBlock)success;
- (void)put:(NSString *)resource withParams:(id)params success:(RequestSuccessBlock)success;
- (void)patch:(NSString *)resource withParams:(id)params success:(RequestSuccessBlock)success;
- (void)del:(NSString *)resource success:(RequestSuccessBlock)success;
- (void)delete:(NSString *)resource success:(RequestSuccessBlock)success; //DEPRECATED
- (void)me:(NSArray *)filter success:(RequestSuccessBlock)success;


@end
