//
//  SecondViewController.m
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 13.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#import "CartViewController.h"
#import "BookTableViewController.h"

#import "BooksManager.h"
#import "Book.h"

#import <MagicalRecord/MagicalRecord.h>
#import "NSObject+Additions.h"


@interface CartViewController ()
{
	BookTableViewController* bookTableVC;
}
@end

@implementation CartViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self setupUI];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateUI];
}

#pragma mark - UI

- (void)setupUI
{
	bookTableVC = self.childViewControllers.firstObject;
	bookTableVC.onDatabase = YES;
	bookTableVC.loadNextDataPageOnCompletion = nil;
}

- (void)updateUI
{
	// Get data from DB
	NSArray* data = [Book MR_findAll];
	BooksPagination pagination = {.offset = 0, .limit = 0, .totalCount = 0, .canLoadPage = NO};
	
	[bookTableVC updateWithData:data pagination:pagination fromScratch:YES];
}

@end
