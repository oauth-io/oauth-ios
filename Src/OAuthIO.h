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
#import "OAuthIORequest.h"


typedef void (^SuccessBlock) (NSData *data, NSURLRequest *request);
typedef void (^ErrorBlock) (NSError *error);

@interface OAuthIO : NSObject <NSURLConnectionDelegate>
{
    NSString *_key;
    NSMutableData *_responseData;
}

@property (nonatomic, copy) SuccessBlock  success;
@property (nonatomic, copy) ErrorBlock    error;

- (id)initWithKey:(NSString *)key;
- (void)redirectWithProvider:(NSString *)provider andUrl:(NSString *)url success:(SuccessBlock)success error:(ErrorBlock)error;

@end

