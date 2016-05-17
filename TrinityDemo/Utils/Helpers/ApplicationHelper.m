//
//  ApplicationHelper.m
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 17.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#import "ApplicationHelper.h"
#import "AppDelegate.h"


@implementation ApplicationHelper

+ (instancetype)shared
{
	static ApplicationHelper* client;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		client = [[self alloc] init];
	});
	
	return client;
}

#pragma mark - API

+ (UIViewController*)topmostViewController
{
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window)
		window = ((AppDelegate*)[UIApplication sharedApplication]).window;
	
	UIViewController* vc = window.rootViewController;
	
	// Iterate over presented view controllers
	while (vc.presentedViewController)
		vc = vc.presentedViewController;
	
	if ([vc isKindOfClass:[UINavigationController class]])
		vc = ((UINavigationController*)vc).visibleViewController;
	
	if ([vc isKindOfClass:[UITabBarController class]])
		vc = ((UITabBarController*)vc).selectedViewController;
	
	return vc;
}

+ (void)showAlertWithError:(NSError*)error onController:(UIViewController*)controller
{
	UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction* action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[ac dismissViewControllerAnimated:YES completion:nil];
	}];
	
	[ac addAction:action];
	[controller presentViewController:ac animated:YES completion:nil];
}

@end
