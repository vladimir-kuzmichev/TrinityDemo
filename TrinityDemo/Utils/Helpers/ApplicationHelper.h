//
//  ApplicationHelper.h
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 17.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ApplicationHelper : NSObject

+ (instancetype)shared;

+ (UIViewController*)topmostViewController;
+ (void)showAlertWithError:(NSError*)error onController:(UIViewController*)controller;

@end
