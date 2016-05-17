//
//  GoogleBooksResponseSerializer.m
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 15.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#import "GoogleBooksResponseSerializer.h"

#import "GoogleBooksAPI.h"
#import "Errors.h"


@implementation GoogleBooksResponseSerializer

// Override protocol method
- (id)responseObjectForResponse:(NSURLResponse *)response
						   data:(NSData *)data
						  error:(NSError *__autoreleasing *)error
{
	NSString* responseString = [[NSString alloc] initWithData:data encoding:self.stringEncoding];
	
	NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
	_httpStatusCode = httpResponse.statusCode;
	
	NSLog(@"JSON response for API request '%@' with HTTP status code '%ld':\n%@\n", response.URL.lastPathComponent, (long)_httpStatusCode, responseString);
	
	NSDictionary* json = [super responseObjectForResponse:response data:data error:error];
	//_error = *error;
	
	return [self parseResponseJSON:json];
}

#pragma mark - Utils

- (id)parseResponseJSON:(NSDictionary*)json
{
	_error = [self errorFromResponse:json];
	return json;
}

- (NSError*)errorFromResponse:(NSDictionary*)response
{
	NSError* error = nil;
	
	NSDictionary* errorInfo = response[kAPIKeyError];
	if (errorInfo)
		error = [NSError errorWithDomain:kErrorDomain code:ApplicationErrorAPIError userInfo:@{NSLocalizedDescriptionKey : errorInfo[kAPIKeyErrorMessage]}];
	
	return error;
}

@end
