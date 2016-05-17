//
//  GoogleBooksResponseSerializer.h
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 15.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface GoogleBooksResponseSerializer : AFJSONResponseSerializer

@property (nonatomic, readonly) NSInteger httpStatusCode;
@property (nonatomic, readonly) NSError* error;

@end
