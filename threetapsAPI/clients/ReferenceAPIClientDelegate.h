//  ReferenceAPIClientDelegate.h
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <UIKit/UIKit.h>

#import "APIError.h"
#import "Category.h"

// ################################################################################################
//
// ReferenceAPIClientDelegate
//
//     This formal protocol defines the methods which a |ReferenceAPIClient| delegate object must
//     implement in order to respond to a completed Reference API call.
//
//     Note that while all the methods of this protocol are optional, an |NSException| will be
//     raised if an API call is made and the required delegate method has not been implemented.

@protocol ReferenceAPIClientDelegate <NSObject>

@optional

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// gotCategories:
//
//     Respond to a |getCategories| API call successfully finishing.
//
//     'categories' will be an |NSArray| of Category objects containing the downloaded categories.
//     The categories will not include annotations.

- (void) gotCategories:(NSArray*)categories;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getCategoriesFailedWithError:
//
//     Respond to an error occurring while performing the |getCategories| API call.

- (void) getCategoriesFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// gotCategoriesWithAnnotations:
//
//     Respond to a |getCategoriesWithAnnotations| API call successfully finishing.
//
//     'categories' will be an |NSArray| of Category objects containing the downloaded categories.
//     The categories will include annotations.

- (void) gotCategoriesWithAnnotations:(NSArray*)categories;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getCategoriesWithAnnotationsFailedWithError:
//
//     Respond to an error occurring while performing the |getCategoriesWithAnnotations| API call.

- (void) getCategoriesWithAnnotationsFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// gotCategory:
//
//     Respond to a |getCategory| API call successfully finishing.
//
//     'category' will be the Category object containing the details of the requested category.
//     The category will include annotations.

- (void) gotCategory:(Category*)category;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getCategoryFailedWithError:
//
//     Respond to an error occurring while performing the |getCategory| API call.

- (void) getCategoryFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// gotLocations:
//
//     Respond to a |getLocations| API call successfully finishing.
//
//     'locations' will be an |NSArray| of Location objects containing the downloaded locations.

- (void) gotLocations:(NSArray*)locations;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getLocationsFailedWithError:
//
//     Respond to an error occurring while performing the |getLocations| API call.

- (void) getLocationsFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// gotSources:
//
//     Respond to a |getSources| API call successfully finishing.
//
//     'sources' will be an |NSArray| of Source objects containing the downloaded data sources.

- (void) gotSources:(NSArray*)sources;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getSourcesFailedWithError:
//
//     Respond to an error occurring while performing the |getSources| API call.

- (void) getSourcesFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
