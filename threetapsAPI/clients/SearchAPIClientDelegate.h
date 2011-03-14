//  SearchAPIClientDelegate.h
//  threetapsAPI
//
//  Created by Erik Westra on 13/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <UIKit/UIKit.h>

#import "APIError.h"

// ################################################################################################
//
// SearchAPIClientDelegate
//
//     This formal protocol defines the methods which a |SearchAPIClient| delegate object must
//     implement in order to respond to a completed Search API call.
//
//     Note that while all the methods of this protocol are optional, an |NSException| will be
//     raised if an API call is made and the required delegate method has not been implemented.

@protocol SearchAPIClientDelegate <NSObject>

@optional

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// gotSearchResults:timeTaken:numPostings:
//
//     Respond to a |search:| API call successfully finishing.
//
//     'results' will be an |NSArray| of |Posting| objects, holding the current page of matching
//     postings; 'execTime' will be the total amount of time taken to execute the search, in
//     milliseconds, and 'numPostings' will be the total number of matching postings in the 3taps
//     database.

- (void) gotSearchResults:(NSArray*)postings timeTaken:(int)execTime numPostings:(int)numPostings;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// searchFailedWithError:
//
//     Respond to an error occurring while performing the |search:| API call.

- (void) searchFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// calculatedRange:
//
//     Respond to a |calculateRangeOfFields:forQuery| API call successfully finishing.
//
//     'results' will be an |NSDictionary| mapping field names to an |NSArray| with two entries,
//     holding the minimum or maximum value for that field.  Note that the 'results' dictionary
//     will not contain an entry for a field if that field's range could not be calculated.

- (void) calculatedRange:(NSDictionary*)results;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// rangeFailedWithError:
//
//     Respond to an error occurring while performing a |calculateRangeOfFields:forQuery| API call.

- (void) rangeFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// calculatedSummary:timeTaken:
//
//     Respond to a |calculateSummaryAcross:forQuery:| API call successfully finishing.
//
//     'summary' will be an |NSDictionary| mapping dimension values to the total number of matching
//     postings for that value, and 'execTime' will be the number of milliseconds that it took the
//     server to calculate the summary.

- (void) calculatedSummary:(NSDictionary*)summary timeTaken:(int)execTime;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// summaryFailedWithError:
//
//     Respond to an error occurring while performing a |calculateSummaryAcross:forQuery| API call.

- (void) summaryFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// countReceived:
//
//     Respond to a |count:| API call successfully finishing.
//
//     'numPosts' will be the total number of postings which match the search criteria passed to
//     the |count:| call.

- (void) countReceived:(int)numPosts;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// countFailedWithError:
//
//     Respond to an error occurring while performing a |count:| API call.

- (void) countFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// gotBestMatchCategory:numPosts:
//
//     Respond to a |bestMatch:| API call successfully finishing.
//
//     'categoryCode' will be the 3taps category code for the category that best matches the
//     supplied keywords, and 'numPosts' will be the total number of postings in that category.

- (void) gotBestMatchCategory:(NSString*)categoryCode numPosts:(int)numPosts;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// bestMatchFailedWithError:
//
//     Respond to an error occurring while performing a |bestMatch:| API call.

- (void) bestMatchFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
