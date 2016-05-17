//
//  BookCell.m
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 16.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#import "BookCell.h"

@interface BookCell ()

- (IBAction)cartBtnPressed:(id)sender;

@end

@implementation BookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self)
	{
		[self setupUI];
	}
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self setupUI];
}

#pragma mark - UI

- (void)setupUI
{
	CALayer* viewLayer = self.cartBtn.layer;
	viewLayer.cornerRadius = 3;
	viewLayer.masksToBounds = YES;
}

#pragma mark - API



#pragma mark - Actions

- (IBAction)cartBtnPressed:(id)sender
{
	if (self.cartBtnPressed)
		self.cartBtnPressed(self);
}

@end
