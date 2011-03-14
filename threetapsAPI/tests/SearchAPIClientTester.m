//  SearchAPIClientTester.m
//  threetapsAPI
//
//  Created by Erik Westra on 12/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "SearchAPIClientTester.h"

// ################################################################################################
//
// Private method definitions:

@interface SearchAPIClientTester (private)

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testSearch
//
//     Test the [SearchAPIClient search:] method.

- (void) testSearch;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testRange
//
//     Test the [SearchAPIClient calculateRangeOfFields:forQuery:] method.

- (void) testRange;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testSummary
//
//     Test the [SearchAPIClient calculateSummaryAcross:] method.

- (void) testSummary;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testCount
//
//     Test the [SearchAPIClient count:] method.

- (void) testCount;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testBestMatch
//
//     Test the [SearchAPIClient bestMatch:] method.

- (void) testBestMatch;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testsFinished
//
//     Tell the rest of the testing framework that our unit tests have finished.
//
//     We call the selector and target object that was passed to our |runWithCompletionTarget|
//     method.

- (void) testsFinished;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################

@implementation SearchAPIClientTester

@synthesize _client;
@synthesize _target;
@synthesize _selector;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self._client = [[SearchAPIClient alloc] init];
    [self._client setDelegate:self];

    self._target   = nil;
    self._selector = nil;

    [self._client release]; // Don't over-retain our instance variables.
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self._client release];
  [self._target release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) runWithCompletionTarget:(NSObject*)target selector:(SEL)selector {

  self._target   = target;
  self._selector = selector;

  [self testSearch];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//              R E F E R E N C E A P I C L I E N T D E L E G A T E   M E T H O D S              //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) gotSearchResults:(NSArray*)postings
                timeTaken:(int)execTime
              numPostings:(int)numPostings {

  NSLog(@"[SearchAPIClient search:] successfully finished, received %d postings",
        [postings count]);

  [self testRange];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) searchFailedWithError:(APIError*)error {

  NSLog(@"[SearchAPIClient search:] failed: %@", [error description]);
  [self testRange];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) calculatedRange:(NSDictionary*)results {

  NSLog(@"[SearchAPIClient calculatedRange:query:] successfully finished");

  if ([results objectForKey:@"price"] != nil) {
    NSArray* price = [results objectForKey:@"price"];
    NSLog(@"minimum price = %@, maximum price = %@",
          [price objectAtIndex:0], [price objectAtIndex:1]);
  }

  [self testSummary];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) rangeFailedWithError:(APIError*)error {

  NSLog(@"[SearchAPIClient calculatePriceRange:query:] failed: %@", [error description]);
  [self testSummary];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) calculatedSummary:(NSDictionary*)summary timeTaken:(int)execTime {

  NSLog(@"[SearchAPIClient calculateSummaryAcross:query:] successfully finished");
  NSLog(@"  time taken = %d ms", execTime);
  for (NSString* key in [summary keyEnumerator]) {
    int value = [[summary objectForKey:key] intValue];
    NSLog(@"  %@ = %d", key, value);
  }

  [self testCount];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) summaryFailedWithError:(APIError*)error {

  NSLog(@"[SearchAPIClient calculateSummaryAcross:query:] failed: %@", [error description]);
  [self testCount];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) countReceived:(int)numPosts {

  NSLog(@"[SearchAPIClient count:] successfully finished, total = %d", numPosts);
  [self testBestMatch];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) countFailedWithError:(APIError*)error {

  NSLog(@"[SearchAPIClient count:] failed: %@", [error description]);
  [self testBestMatch];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) gotBestMatchCategory:(NSString*)categoryCode numPosts:(int)numPosts {

  NSLog(@"[SearchAPIClient bestMatch:] successfully finished, category = %@, numPosts = %d",
        categoryCode, numPosts);
  [self testsFinished];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) bestMatchFailedWithError:(APIError*)error {

  NSLog(@"[SearchAPIClient bestMatch:] failed: %@", [error description]);
  [self testsFinished];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                 P R I V A T E   M E T H O D S                                 //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testSearch {

  NSLog(@"Testing [SearchAPIClient search:] API call...");

  SearchQuery* query = [[SearchQuery alloc] init];
  query.source   = @"CRAIG";
  query.location = @"SFO";
  query.text     = @"bike";

  [self._client search:query];
  [query release];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testRange {

  NSLog(@"Testing [SearchAPIClient calculateRangeOfFields:forQuery:] API call...");

  SearchQuery* query = [[SearchQuery alloc] init];
  query.source   = @"CRAIG";
  query.location = @"SFO";
  query.text     = @"bike";

  [self._client calculateRangeOfFields:[NSArray arrayWithObject:@"price"] forQuery:query];
  [query release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testSummary {

  NSLog(@"Testing [SearchAPIClient calculateSummaryAcross:forQuery:] API call...");

  SearchQuery* query = [[SearchQuery alloc] init];
  query.source   = @"CRAIG";
  query.location = @"SFO";
  query.text     = @"bike";

  [self._client calculateSummaryAcross:@"category" forQuery:query];
  [query release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testCount {

  NSLog(@"Testing [SearchAPIClient count:] API call...");

  SearchQuery* query = [[SearchQuery alloc] init];
  query.source   = @"CRAIG";
  query.location = @"SFO";
  query.text     = @"bike";

  [self._client count:query];
  [query release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testBestMatch {

  NSLog(@"Testing [SearchAPIClient bestMatch:] API call...");

  [self._client bestMatch:[NSArray arrayWithObject:@"iPad"]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testsFinished {

  [self._target performSelector:self._selector];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
