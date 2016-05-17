//
//  GoogleBooksAPIClient.h
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 15.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void(^APIRequestCompletionBlock)(NSDictionary* data, NSError* error);

extern NSString* const kAPIBaseURL;
extern NSString* const kHTTPMethodGet;
extern NSString* const kHTTPMethodPost;


@interface GoogleBooksAPIClient : AFHTTPSessionManager

+ (instancetype)shared;

- (void)makeRequest:(NSString*)requestPath onCompletion:(APIRequestCompletionBlock)completion;
- (void)makeRequest:(NSString*)requestPath parameters:(NSDictionary*)parameters onCompletion:(APIRequestCompletionBlock)completion;
- (void)makeRequest:(NSString*)requestPath withMethod:(NSString*)httpMethod parameters:(NSDictionary*)parameters onCompletion:(APIRequestCompletionBlock)completion;

@end
