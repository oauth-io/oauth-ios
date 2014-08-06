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

@interface OAuthIOData : NSObject

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)getCredentials;

@property (nonatomic, strong) NSMutableDictionary     *request;
@property (nonatomic, strong) NSDictionary            *request_parameters;
@property (nonatomic, strong) NSDictionary            *request_query;
@property (nonatomic, strong) NSDictionary            *request_headers;
@property (nonatomic, strong) NSDictionary            *request_conf;

@property (nonatomic, strong) NSString                *oauth_token;
@property (nonatomic, strong) NSString                *code;
@property (nonatomic, strong) NSString                *oauth_token_secret;
@property (nonatomic, strong) NSString                *access_token;
@property (nonatomic, strong) NSString                *request_url;
@property (nonatomic, strong) NSString                *provider;
@property (nonatomic, strong) NSDictionary            *credentials;



@end