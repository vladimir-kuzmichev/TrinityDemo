//
//  BooksManager.h
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 15.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Book;

typedef void(^ItemsListCompletionBlock)(NSArray* data, NSError* error);
typedef void(^BookDetailsCompletionBlock)(Book* data, NSError* error);

typedef struct {
	NSInteger offset;
	NSInteger limit;
	NSInteger totalCount;
	BOOL canLoadPage;
} BooksPagination;


@interface BooksManager : NSObject

+ (instancetype)shared;

- (void)searchBooksWithQuery:(NSString*)query pagination:(BooksPagination*)pagination onCompletion:(ItemsListCompletionBlock)completion;
- (void)loadBookDetails:(NSString*)itemId onCompletion:(BookDetailsCompletionBlock)completion;
- (void)saveBookToDatabase:(Book*)book;

@end
