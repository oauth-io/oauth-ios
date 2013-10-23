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

typedef void (^RequestSuccessBlock) (NSData *data, NSURLRequest *request);
typedef void (^RequestErrorBlock) (NSError *error);

@interface OAuthIORequest : NSObject<NSURLConnectionDelegate>
{
    NSURLConnection     *_connection;
    NSMutableURLRequest *_req;
    NSMutableData       *_responseData;
    NSString            *_baseUrl;
}

@property (nonatomic, copy) RequestSuccessBlock success;
@property (nonatomic, copy) RequestErrorBlock   error;
@property (nonatomic, copy) NSURLRequest *request;

- (id) initWithBaseUrl:(NSString *)baseUrl;
- (void) requestWithParams:(NSDictionary *)params success:(RequestSuccessBlock)success error:(RequestErrorBlock)error;
+ (NSString *)encodeURL:(NSString *)str;
+ (NSString*)decodeURL:(NSString *)str;

@end
