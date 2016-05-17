//
//  BookDetailsViewController.m
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 17.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#import "BookDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "Book.h"


@interface BookDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *detailsView;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *authorsLbl;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;

@end

@implementation BookDetailsViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateUI];
}

#pragma mark - Getters/Setters

- (void)setTheBook:(Book *)theBook
{
	_theBook = theBook;
	[self updateUI];
}

#pragma mark - UI

- (void)setupUI
{
	
}

- (void)updateUI
{
	if (!self.isViewLoaded)
		return;
	
	[self.thumbnailView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:self.theBook.thumbnailUrl] placeholderImage:nil options:0 progress:nil completed:nil];
	
	self.titleLbl.text = self.theBook.title;
	self.authorsLbl.text = self.theBook.author;
	self.descriptionView.text = self.theBook.desc;
}

@end
