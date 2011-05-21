//  SearchAPIClient.h
//  threetapsAPI
//
//  Created by Erik Westra on 13/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

#import "APIClient.h"
#import "SearchAPIClientDelegate.h"

// ################################################################################################

@class SearchQuery;

// ################################################################################################
//
// SearchAPIClient
//
//     This 3taps API client provides asynchronous access to the 3taps Search API.

@interface SearchAPIClient : APIClient {

  @private
  <SearchAPIClientDelegate> _delegate;
}

@property (nonatomic, retain) <SearchAPIClientDelegate> _delegate;

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
//     Set our |SearchAPIClientDelegate| object.
//
//     Our delegate object will respond when Search API calls have been completed.

- (void) setDelegate:(<SearchAPIClientDelegate>)delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// search:
//
//     Perform a search against the 3taps posting database.
//
//     The supplied |SearchQuery| object contains the search terms to search against, as well as
//     additional fields (rpp, page and retvals) that control the search results.  Upon completion,
//     one of the following delegate methods will be called, as appropriate:
//
//         gotSearchResults:timeTaken:numPostings:
//         searchFailedWithError:

- (void) search:(SearchQuery*)query;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// calculateRangeOfFields:forQuery:
//
//     Calculate the minimum and maximum values for a given search query.
//
//     The parameters are as follows:
//
//         fields
//
//             An |NSArray| of field names to calculate the range for.
//
//         query
//
//             A |SearchQuery| object defining the parameters for a search.
//
//     The 3taps server will attempt to calculate the minimum and maximum value for each of the
//     specified fields, across all postings that match the given search query.
//
//     Upon completion, one of the following delegate methods will be called, as appropriate:
//
//         calculatedRange:
//         rangeFailedWithError:

- (void) calculateRangeOfFields:(NSArray*)fields forQuery:(SearchQuery*)query;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// calculateSummaryAcross:forQuery:
//
//     Calculate the number of matching postings across a given dimension.
//
//     The parameters are as follows:
//
//         dimension
//
//             The name of a field to calculate the summary across.  The following dimension values
//             are currently supported:
//
//                 source
//                 category
//                 location
//
//         query
//
//             A |SearchQuery| object defining the parameters for a search.
//
//     We calculate the number of matching postings for each value across the given dimesion.  For
//     example, where 'dimension' is set to "source", we calculate the total number of matching
//     postings for each source.
//
//     Upon completion, one of the following delegate methods will be called, as appropriate:
//
//         calculatedSummary:timeTaken:
//         summaryFailedWithError:

- (void) calculateSummaryAcross:(NSString*)dimension forQuery:(SearchQuery*)query;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// count:
//
//     Calculate the number of postings which match the given search criteria.
//
//     'query' should be a |SearchQuery| object defining the parameters for a search.  We calculate
//     the total number of postings which match that search query.
//
//     Upon completion, one of the following delegate methods will be called, as appropriate:
//
//         countReceived:
//         countFailedWithError:

- (void) count:(SearchQuery*)query;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################
//
// SearchQuery
//
//     A |SearchQuery| object encapsulates the various parts of a 3taps search query.
//
//     Any combination of the following fields can be used to define a search query:
//
//         source
//
//             The 5-character source code a posting must have if it is to be included in the list
//             of search results.
//
//         category
//
//             The 4-character category code a posting must have if it is to be included in the
//             list of search results.  Note that multiple categories can be searched by passing in
//             multiple category codes, separated by +OR+.
//
//         location
//
//             The 3-character location code a posting must have if it is to be included in the
//             list of search results.  Note that multiple locations can be searched by passing in
//             multiple location codes, separated by +OR+.
//
//         heading
//
//             A string which must occur in the heading of the posting if it is to be included in
//             the list of search results.
//
//         body
//
//             A string which must occur in the body of the posting if it is to be included in the
//             list of search results.
//
//         text
//
//             A string which must occur in either the heading or the body of the posting if it is
//             to be included in the list of search results.
//
//         externalID
//
//             A string which must match the "externalID" field for a posting if it is to be
//             included in the list of search results.
//
//         start
//
//             An |NSDate| object defining the desired starting timeframe for the search query.
//             Only postings with a timestamp greater than or equal to the given value will be
//             included in the list of search results.  Note that the specified time and date must
//             be in UTC.
//
//         end
//
//             An |NSDate| object defining the desired ending timeframe for the search query.  Only
//             postings with a timestamp less than or equal to the given value will be included in
//             the list of search results.  Note that the specified time and date must be in UTC.
//
//         annotations
//
//             A dictionary of key/value pairs that a posting must have in its annotations to be
//             included in the list of search results.
//
//         trustedAnnotations
//
//             A dictionary of key/value pairs that a posting must have in its trusted annotations
//             to be included in the list of search results.
//
//     In addition, the following fields can be used to control the behaviour of the |search:|
//     method.  These fields are ignored by the other |SearchAPIClient| methods.
//
//         rpp
//
//             The number of results to return per page.  If this is not specified, a maximum of
//             ten postings will be returned.  If this is set to -1, all matching postings will be
//             returned.
//
//         page
//
//             The page number of the results to return, where zero is the most recent page.  If
//             this is not specified, the most recent page of results will be returned.
//
//         retvals
//
//             An |NSArray| of field names to return for each matching posting.  The following
//             field names are currently supported:
//
//                 source
//                 category
//                 location
//                 longitude
//                 latitude
//                 heading
//                 body
//                 images
//                 externalURL
//                 userID
//                 timestamp
//                 externalID
//                 annotations
//                 postKey
//
//             If 'retvals' is not set, the following default set of fields will be returned:
//
//                 category
//                 location
//                 heading
//                 externalURL
//                 timestamp
//
//     You can retrieve and change these attributes directly as required.

@interface SearchQuery : NSObject {
  @public
  NSString*     source;
  NSString*     category;
  NSString*     location;
  NSString*     heading;
  NSString*     body;
  NSString*     text;
  NSString*     externalID;
  NSDate*       start;
  NSDate*       end;
  NSDictionary* annotations;
  NSDictionary* trustedAnnotations;
  int           rpp;
  int           page;
  NSArray*      retvals;
}

@property (nonatomic, retain) NSString*     source;
@property (nonatomic, retain) NSString*     category;
@property (nonatomic, retain) NSString*     location;
@property (nonatomic, retain) NSString*     heading;
@property (nonatomic, retain) NSString*     body;
@property (nonatomic, retain) NSString*     text;
@property (nonatomic, retain) NSString*     externalID;
@property (nonatomic, retain) NSDate*       start;
@property (nonatomic, retain) NSDate*       end;
@property (nonatomic, retain) NSDictionary* annotations;
@property (nonatomic, retain) NSDictionary* trustedAnnotations;
@property (nonatomic, assign) int           rpp;
@property (nonatomic, assign) int           page;
@property (nonatomic, retain) NSArray*      retvals;

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

@end
