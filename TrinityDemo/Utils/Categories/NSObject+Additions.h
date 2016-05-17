//
//  NSObject+Additions.h
//  skulo
//
//  Created by Vladimir Kuzmichev on 11/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IsEmpty(object) [NSObject isEmpty:object]


@interface NSObject (Additions)

+ (BOOL)isEmpty:(id)object;

@end
