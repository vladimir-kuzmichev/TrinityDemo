//
//  BookTableViewController.m
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 16.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#import "BookTableViewController.h"
#import "BookDetailsViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <MagicalRecord/MagicalRecord.h>

#import "BooksManager.h"
#import "BookCell.h"
#import "Book.h"


@interface BookTableViewController ()
{
	NSMutableArray* bookList;
	BooksPagination booksPagination;
	
	UIButton* paginationBtn;
}

@property (weak, nonatomic) IBOutlet UITableView *bookTable;

@end

@implementation BookTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
	{
		bookList = [NSMutableArray array];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self setupUI];
}

#pragma mark - API

- (void)updateWithData:(NSArray*)data pagination:(BooksPagination)pagination fromScratch:(BOOL)fromScratch
{
	// Clear the data source
	if (fromScratch)
		[bookList removeAllObjects];
	
	[bookList addObjectsFromArray:data];
	booksPagination = pagination;
	
	[self.bookTable reloadData];
	[self updatePaginationUI];
}

#pragma mark - UI

- (void)setupUI
{
	// Pagination button
	//
	paginationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
	paginationBtn.frame = CGRectMake(0, 0, 120, 30);
	
	paginationBtn.backgroundColor = [UIColor orangeColor];
	paginationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:10];
	
	[paginationBtn setTintColor:[UIColor whiteColor]];
	//[paginationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	CALayer* layer = paginationBtn.layer;
	layer.cornerRadius = 3;
	layer.masksToBounds = YES;
	
	[paginationBtn setTitle:[NSLocalizedString(@"Show more", nil) uppercaseString] forState:UIControlStateNormal];
	[paginationBtn addTarget:self action:@selector(paginationBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
	//
}

- (void)updatePaginationUI
{
	if (booksPagination.canLoadPage)
	{
		UIView* view = self.bookTable.tableFooterView;
		if (!view)
		{
			view = [[UIView alloc] initWithFrame:self.bookTable.bounds];
			view.backgroundColor = [UIColor clearColor];
			
			CGRect frame = view.frame;
			frame.size.height = 55;
			view.frame = frame;
			
			paginationBtn.center = CGPointMake(CGRectGetWidth(frame) / 2, CGRectGetHeight(frame) / 2);
			
			[view addSubview:paginationBtn];
			[self.bookTable setTableFooterView:view];
		}
	}
	else
		[UIView animateWithDuration:0.25 delay:0 options:0 animations:^{
			self.bookTable.tableFooterView = nil;
		} completion:nil];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger count = bookList.count;
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString* cellId = self.onDatabase ? @"BookDBCell" : @"BookCell";
	BookCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
	
	Book* theBook = bookList[indexPath.row];
	
	// Setting up the cell
	cell.titleLbl.text = theBook.title;
	cell.authorsLbl.text = theBook.author;
	
	[cell.thumbnailView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:theBook.thumbnailUrl] placeholderImage:nil options:SDWebImageAvoidAutoSetImage progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		
		if (!image)
			return;
		
		// Animate image displaying if it was pulled from the web
		if (cacheType == SDImageCacheTypeNone)
		{
			[UIView transitionWithView:cell.thumbnailView duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
				cell.thumbnailView.image = image;
			} completion:nil];
		}
		else
			cell.thumbnailView.image = image;
		
	}];
	
	if (!self.onDatabase)
	{
		// Disable Cart button if the book is in DB, Enable otherwise
		Book* item = [Book MR_findFirstByAttribute:@"itemId" withValue:theBook.itemId];
		cell.cartBtn.enabled = (item ? NO : YES);
	}
	
	cell.cartBtnPressed = ^(BookCell* c) {
		
		NSIndexPath* path = [tableView indexPathForCell:c];
		Book* item = bookList[path.row];
		
		// Add item to the cart
		[[BooksManager shared] saveBookToDatabase:item];
		
		// Refresh the cell
		[tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
		
	};
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Book* theBook = bookList[indexPath.row];
	[self performSegueWithIdentifier:@"showDetails" sender:theBook];
}

#pragma mark - UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"showDetails"])
	{
		BookDetailsViewController* vc = segue.destinationViewController;
		vc.theBook = sender;
	}
}

#pragma mark - Unwind segue support

- (IBAction)unwindToBookTableVC:(UIStoryboardSegue*)segue
{
	
}

#pragma mark - Actions

- (void)paginationBtnPressed:(id)sender
{
	if (self.loadNextDataPageOnCompletion)
	{
		paginationBtn.enabled = NO;
		self.loadNextDataPageOnCompletion(^() {
			paginationBtn.enabled = YES;
		});
	}
}

@end
