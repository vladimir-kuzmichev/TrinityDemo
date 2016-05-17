//
//  GoogleBooksAPIClient.m
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 15.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#import "GoogleBooksAPIClient.h"

#import "GoogleBooksResponseSerializer.h"
#import "Errors.h"
#import "GoogleBooksAPI.h"

NSString* const kAPIBaseURL = @"https://www.googleapis.com/books/v1/";
NSString* const KAPIKey = @"AIzaSyDCj6okZId4lNidX2dFw566BAeEg_Bn5-Y";

NSString* const kHTTPMethodGet = @"GET";
NSString* const kHTTPMethodPost = @"POST";


@implementation GoogleBooksAPIClient

+ (instancetype)shared
{
	static GoogleBooksAPIClient* client;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		client = [[self alloc] init];
	});
	
	return client;
}

- (id)init
{
	self = [super initWithBaseURL:[NSURL URLWithString:kAPIBaseURL] sessionConfiguration:nil];
	if (self)
	{
		// Serializers
		self.requestSerializer = [AFHTTPRequestSerializer serializer];
		self.responseSerializer = [GoogleBooksResponseSerializer serializer];
		
		// Initial setup
		[self setup];
	}
	return self;
}

- (void)setup
{
	__weak typeof(self) wself = self;
	
	[self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
		
		NSString* statusStr = wself.reachabilityManager.localizedNetworkReachabilityStatusString;
		NSLog(@"Reachability status for 'www.googleapis.com': %@\n\n", statusStr);
		
	}];
	
	[self.reachabilityManager startMonitoring];
}

#pragma mark - API

- (void)makeRequest:(NSString*)requestPath onCompletion:(APIRequestCompletionBlock)completion
{
	[self makeRequest:requestPath parameters:nil onCompletion:completion];
}

- (void)makeRequest:(NSString*)requestPath parameters:(NSDictionary*)parameters onCompletion:(APIRequestCompletionBlock)completion
{
	[self makeRequest:requestPath withMethod:kHTTPMethodGet parameters:parameters onCompletion:completion];
}

- (void)makeRequest:(NSString*)requestPath withMethod:(NSString*)httpMethod parameters:(NSDictionary*)parameters onCompletion:(APIRequestCompletionBlock)completion
{
	NSLog(@"Attempt to perform API request '%@'...", requestPath);
	
	// Build request URL
	NSURL* requestUrl = [self.baseURL URLByAppendingPathComponent:requestPath];
	
	// Cancel all the same previous requests
	[self cancelRequestsByURL:requestUrl];
	
	// First check the internet connection
	if (!self.reachabilityManager.isReachable)
	{
		NSError* error = [self createConnectionError];
		NSLog(@"Connection error: %@", error);
		
		// Post notification for subscribers
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationApplicationError object:self userInfo:@{@"error" : error}];
		
		if (completion)
			completion(nil, error);
		
		return;
	}
	
	// Modify request params (append the API key)
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:(parameters ? parameters : @{})];
	params[kAPIKeyKey] = KAPIKey;
	
	NSLog(@"Request URL: %@", requestUrl);
	NSLog(@"Request parameters: %@\n", params);
	
	// Construct URL Request
	NSError *serializationError = nil;
	NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:httpMethod URLString:[requestUrl absoluteString] parameters:params error:&serializationError];
	
	if (serializationError)
	{
		NSLog(@"Request serialization error: %@", serializationError);
		
		if (completion)
			completion(nil, serializationError);
		
		return;
	}
	
	NSURLSessionDataTask* dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
		
		GoogleBooksResponseSerializer* serializer = (GoogleBooksResponseSerializer*)self.responseSerializer;
		
		// Check for API request error
		if (serializer.error)
		{
			NSLog(@"Response error: %@", serializer.error);
			
			// Post notification for subscribers
			[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationApplicationError object:self userInfo:@{@"error" : serializer.error}];
			
			if (completion)
				completion(nil, serializer.error);
			
			return;
		}
		
		// Check for server error
		if (error)
		{
			NSLog(@"Server error: %@", error);
			
			if (error.code != -999)		// "Cancelled"
			{
				// Post notification for subscribers
				[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationApplicationError object:self userInfo:@{@"error" : error}];
			}
			
			if (completion)
				completion(nil, error);
			
			return;
		}
		
		if (completion)
			completion(responseObject, nil);
		
	}];
	
	// Start the data task
	[dataTask resume];
}

#pragma mark - Utils

- (void)cancelRequestsByURL:(NSURL*)url
{
	NSArray* tasks = self.tasks;
	for (NSURLSessionTask* item in tasks)
	{
		NSURL* requestURL = item.originalRequest.URL;
		if ([requestURL.path isEqualToString:url.path])
			[item cancel];
	}
}

- (NSError*)createConnectionError
{
	// Generate connection error
	NSError* error = [NSError errorWithDomain:kErrorDomain code:ApplicationErrorNoConnection userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(@"There are problems with network connection. Please try again later", nil)}];
	return error;
}

@end
