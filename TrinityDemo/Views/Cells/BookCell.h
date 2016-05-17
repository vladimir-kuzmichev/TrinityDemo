//
//  BookCell.h
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 16.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *authorsLbl;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;

@property (nonatomic, copy) void(^cartBtnPressed)(BookCell* cell);

@end
