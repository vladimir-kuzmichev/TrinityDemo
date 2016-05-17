//
//  BookTableViewController.h
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 16.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BooksManager.h"


@interface BookTableViewController : UIViewController

@property (nonatomic) BOOL onDatabase;
@property (nonatomic, copy) void(^loadNextDataPageOnCompletion)(void(^completion)());

- (void)updateWithData:(NSArray*)data pagination:(BooksPagination)pagination fromScratch:(BOOL)fromScratch;

- (IBAction)unwindToBookTableVC:(UIStoryboardSegue*)segue;

@end
