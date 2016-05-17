//
//  BooksManager.m
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 15.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#import "BooksManager.h"

#import "Book.h"
#import "GoogleBooksAPIClient.h"
#import "GoogleBooksAPI.h"

#import "NSObject+Additions.h"
#import <MagicalRecord/MagicalRecord.h>


@implementation BooksManager

+ (instancetype)shared
{
	static BooksManager* manager;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		manager = [[self alloc] init];
	});
	
	return manager;
}

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		
	}
	return self;
}

#pragma mark - API

- (void)searchBooksWithQuery:(NSString*)query pagination:(BooksPagination*)pagination onCompletion:(ItemsListCompletionBlock)completion
{
	// Get data from service
	NSDictionary* params = @{kAPIKeyProjection : kAPIKeyProjectionLite, kAPIKeyQuery : (query ? query : @""), kAPIKeyPaginationPage : @((*pagination).offset), kAPIKeyPaginationSize : @((*pagination).limit)};
	[[GoogleBooksAPIClient shared] makeRequest:kAPIRequestGetVolumes parameters:params onCompletion:^(NSDictionary *data, NSError *error) {
		
		NSMutableArray* books = [NSMutableArray array];
		
		if (data)
		{
			NSArray* items = data[kAPIKeyItems];
			for (NSDictionary* item in items)
			{
				Book* theBook = [self parseBookData:item];
				if (theBook)
					[books addObject:theBook];
			}
			
			// Pagination
			(*pagination).totalCount = [data[kAPIKeyItemsCount] integerValue];
		}
		
		if (completion)
			completion(books, error);
		
	}];
}

- (void)loadBookDetails:(NSString*)itemId onCompletion:(BookDetailsCompletionBlock)completion
{
	// Get data from service
	NSString* requestPath = [NSString stringWithFormat:kAPIRequestGetVolumeDetails, itemId];
	NSDictionary* params = @{kAPIKeyProjection : kAPIKeyProjectionFull};
	
	[[GoogleBooksAPIClient shared] makeRequest:requestPath parameters:params onCompletion:^(NSDictionary *data, NSError *error) {
		
		Book* theBook = nil;
		
		if (data)
		{
			theBook = [self parseBookData:data];
		}
		
		if (completion)
			completion(theBook, error);
		
	}];
}

- (void)saveBookToDatabase:(Book*)book
{
	// Create and save the model object
	Book* theBook = [Book MR_findFirstOrCreateByAttribute:@"itemId" withValue:book.itemId];
	
	theBook.itemId = book.itemId;
	theBook.title = book.title;
	theBook.author = book.author;
	theBook.desc = book.desc;
	theBook.thumbnailUrl = book.thumbnailUrl;
	
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

#pragma mark - Parsing

- (Book*)parseBookData:(NSDictionary*)data
{
	if (IsEmpty(data))
		return nil;
	
	Book* item = [Book MR_createEntityInContext:nil];
	
	item.itemId = data[kAPIKeyVolumeId];
	item.title = data[kAPIKeyVolumeInfo][kAPIKeyVolumeTitle];
	
	NSArray* authors = data[kAPIKeyVolumeInfo][kAPIKeyVolumeAuthors];
	item.author = [authors componentsJoinedByString:@", "];
	
	item.desc = data[kAPIKeyVolumeInfo][kAPIKeyVolumeDescription];
	item.thumbnailUrl = data[kAPIKeyVolumeInfo][kAPIKeyVolumeImages][kAPIKeyVolumeImageThumbnail];
	
	return item;
}

@end
