//
//  Errors.h
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 15.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#ifndef Errors_h
#define Errors_h

static NSString* const kErrorDomain = @"com.trinity.TrinityDemo";
static NSString* const kNotificationApplicationError = @"com.trinity.TrinityDemo.NotificationApplicationError";

typedef NS_ENUM(NSInteger, ApplicationError) {
	ApplicationErrorNoConnection = 1,
	ApplicationErrorAPIError
};

#endif /* Errors_h */
