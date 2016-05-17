//
//  FirstViewController.m
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 13.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#import "BookListViewController.h"

#import "BookTableViewController.h"
#import "BooksManager.h"
#import "NSObject+Additions.h"

static NSInteger const kBooksPaginationLimit = 10;


@interface BookListViewController ()
{
	BookTableViewController* bookTableVC;
	
	BooksPagination booksPagination;
	NSString* searchTextValidated;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, copy) void(^loadDataOnCompletion)(void(^completion)());

@end

@implementation BookListViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self setupUI];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setupUI
{
	bookTableVC = self.childViewControllers.firstObject;
	bookTableVC.onDatabase = NO;
	
	__weak typeof(self) wself = self;
	bookTableVC.loadNextDataPageOnCompletion = ^(void(^completion)()) {
		[wself loadBooksOnCompletion:completion];
	};
}

#pragma mark - Pagination

- (void)resetPagination
{
	booksPagination.offset = 0;
	booksPagination.limit = kBooksPaginationLimit;
	booksPagination.totalCount = 0;
	booksPagination.canLoadPage = NO;
}

- (void)updatePagination
{
	booksPagination.offset += booksPagination.limit;
	booksPagination.canLoadPage = (booksPagination.totalCount > booksPagination.offset);
	
	NSLog(@"Pagination: Offset %ld, Count %ld, Page available: %@", (long)booksPagination.offset, (long)booksPagination.totalCount, @(booksPagination.canLoadPage));
}

#pragma mark - Utils

- (void)searchBooksWithText:(NSString*)text
{
	// Reset pagination info
	[self resetPagination];
	
	// Start search when we have at least 2 typed letters
	searchTextValidated = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if (IsEmpty(searchTextValidated) || searchTextValidated.length < 3)
		return;
	
	[self loadBooksOnCompletion:nil];
}

- (void)loadBooksOnCompletion:(void(^)())completion
{
	[[BooksManager shared] searchBooksWithQuery:searchTextValidated pagination:&booksPagination onCompletion:^(NSArray *data, NSError *error) {
		
		if (!IsEmpty(data))
		{
			[self updatePagination];
			[bookTableVC updateWithData:data pagination:booksPagination fromScratch:(booksPagination.offset <= booksPagination.limit)];
		}
		
		if (completion)
			completion();
		
	}];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[self searchBooksWithText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self searchBooksWithText:searchBar.text];
	[searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:YES animated:YES];
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:NO animated:YES];
	return YES;
}

@end
