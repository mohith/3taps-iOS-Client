//  ReferenceAPIClient.h
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

#import "APIClient.h"
#import "ReferenceAPIClientDelegate.h"

// ################################################################################################
//
// ReferenceAPIClient
//
//     This 3taps API client provides asynchronous access to the 3taps Reference API.

@interface ReferenceAPIClient : APIClient {

  @private
  <ReferenceAPIClientDelegate> _delegate;
}

@property (nonatomic, retain) <ReferenceAPIClientDelegate> _delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// init
//
//     Our designated initializer.

- (id) init;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// dealloc
//
//     Release the memory used by our instance variables.

- (void) dealloc;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// setDelegate:
//
//     Set our |ReferenceAPIClientDelegate| object.
//
//     Our delegate object will respond when Reference API calls have been completed.

- (void) setDelegate:(<ReferenceAPIClientDelegate>)delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getCategories
//
//     Retrieve a list of all the categories from the 3taps Reference API.
//
//     A complete list of all 3taps categories (without annotations) will be downloaded from the
//     3taps server.  Upon completion, one of the following delegate methods will be called as
//     appropriate:
//
//         gotCategories:
//         getCategoriesFailedWithError:

- (void) getCategories;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getCategoriesWithAnnotations
//
//     Retrieve a list of all the categories from the 3taps Reference API.
//
//     A complete list of all 3taps categories (with annotations) will be downloaded from the 3taps
//     server.  Upon completion, one of the following delegate methods will be called as
//     appropriate:
//
//          gotCategoriesWithAnnotations:
//          getCategoriesWithAnnotationsFailedWithError:

- (void) getCategoriesWithAnnotations;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getCategory:
//
//     Retrieve the full details (including annotations) for a single category.
//
//     The details of the category with the given category code will be downloaded from the 3taps
//     server.  Upon completion, one of the following delegate methods will be called as
//     appropriate:
//
//              gotCategory:
//              getCategoryFailedWithError:

- (void) getCategory:(NSString*)categoryCode;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getLocations
//
//     Retrieve a list of all the locations from the 3taps Reference API.
//
//     A complete list of all 3taps locations will be downloaded from the 3taps server.  Upon
//     completion, one of the following delegate methods will be called as appropriate:
//
//         gotLocations:
//         getLocationsFailedWithError:

- (void) getLocations;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getSources
//
//     Retrieve a list of all the data sources from the 3taps Reference API.
//
//     A complete list of all 3taps data sources will be downloaded from the 3taps server.  Upon
//     completion, one of the following delegate methods will be called as appropriate:
//
//         gotSources:
//         getSourcesFailedWithError:

- (void) getSources;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
