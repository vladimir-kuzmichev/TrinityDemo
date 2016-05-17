//
//  GoogleBooksAPI.h
//  TrinityDemo
//
//  Created by Vladimir Kuzmichev on 15.05.16.
//  Copyright © 2016 Vladimir Kuzmichev. All rights reserved.
//

#ifndef GoogleBooksAPI_h
#define GoogleBooksAPI_h

static NSString* const kAPIRequestGetVolumes = @"volumes";
static NSString* const kAPIRequestGetVolumeDetails = @"volumes/%@";

static NSString* const kAPIKeyQuery = @"q";
static NSString* const kAPIKeyKey = @"key";
static NSString* const kAPIKeyPaginationPage = @"startIndex";
static NSString* const kAPIKeyPaginationSize = @"maxResults";
static NSString* const kAPIKeyProjection = @"projection";
static NSString* const kAPIKeyProjectionFull = @"full";
static NSString* const kAPIKeyProjectionLite = @"lite";

static NSString* const kAPIKeyItems = @"items";
static NSString* const kAPIKeyItemsCount = @"totalItems";

static NSString* const kAPIKeyVolumeId = @"id";
static NSString* const kAPIKeyVolumeInfo = @"volumeInfo";
static NSString* const kAPIKeyVolumeTitle = @"title";
static NSString* const kAPIKeyVolumeAuthors = @"authors";
static NSString* const kAPIKeyVolumeDescription = @"description";
static NSString* const kAPIKeyVolumeImages = @"imageLinks";
static NSString* const kAPIKeyVolumeImageThumbnail = @"thumbnail";

static NSString* const kAPIKeyError = @"error";
static NSString* const kAPIKeyErrorCode = @"code";
static NSString* const kAPIKeyErrorMessage = @"message";

#endif /* GoogleBooksAPI_h */
