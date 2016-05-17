//
//  NSObject+Additions.m
//  skulo
//
//  Created by Vladimir Kuzmichev on 11/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSObject+Additions.h"

@implementation NSObject (Additions)

+ (BOOL)isEmpty:(id)object
{
	BOOL isNilOrNull = (object == nil || object == [NSNull null]);
	BOOL isZeroLength = ([object respondsToSelector:@selector(length)] && [object performSelector:@selector(length)] == 0);
	BOOL isZeroCount = ([object respondsToSelector:@selector(count)] && [object performSelector:@selector(count)] == 0);
	
	BOOL result = isNilOrNull || isZeroLength || isZeroCount;
	
	return result;
}

@end
