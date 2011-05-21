//  SearchAPIClient.m
//  threetapsAPI
//
//  Created by Erik Westra on 13/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "JSON.h"

#import "SearchAPIClient.h"

#import "APIConnection.h"
#import "APIData.h"
#import "APIError.h"
#import "APIUtils.h"
#import "Posting.h"

// ################################################################################################
//
// Private method definitions:

@interface SearchAPIClient (private)

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// searchFinishedWith:
//
//    Respond to our 'search' API call finishing or failing.

- (void) searchFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// rangeFinishedWith:
//
//    Respond to our 'range' API call finishing or failing.

- (void) rangeFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// summaryFinishedWith:
//
//    Respond to our 'summary' API call finishing or failing.

- (void) summaryFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// countFinishedWith:
//
//    Respond to our 'count' API call finishing or failing.

- (void) countFinishedWith:(APIConnection*)connection;

//
// queryToDictionary:
//
//     Convert a |SearchQuery| object to an |NSDictionary| of search parameters.
//
//     We create a mutable dictionary with key/value pairs matching the contents of the given
//     |SearchQuery| object.

- (NSMutableDictionary*) queryToDictionary:(SearchQuery*)query;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################

@implementation SearchAPIClient

@synthesize _delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self._delegate = nil;
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self._delegate release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) setDelegate:(<SearchAPIClientDelegate>)delegate {

  self._delegate = delegate;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) search:(SearchQuery*)query {

  NSDictionary* args = [self queryToDictionary:query];

  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"search"]];
  [connection setFormValues:args];
  [connection setTarget:self
           withSelector:@selector(searchFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];

  [connection release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) calculateRangeOfFields:(NSArray*)fields forQuery:(SearchQuery*)query {

  NSDictionary* args = [NSDictionary dictionaryWithObject:[fields componentsJoinedByString:@","]
                                                   forKey:@"fields"];

  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"search/range"]];
  [connection setFormValues:args];
  [connection setTarget:self
           withSelector:@selector(rangeFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];

  [connection release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) calculateSummaryAcross:(NSString*)dimension forQuery:(SearchQuery*)query {

  NSMutableDictionary* args = [self queryToDictionary:query];
  [args setObject:dimension forKey:@"dimension"];

  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"search/summary"]];
  [connection setFormValues:args];
  [connection setTarget:self
           withSelector:@selector(summaryFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];

  [connection release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) count:(SearchQuery*)query {

  NSDictionary* args = [self queryToDictionary:query];

  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"search/count"]];
  [connection setFormValues:args];
  [connection setTarget:self
           withSelector:@selector(countFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];

  [connection release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                 P R I V A T E   M E T H O D S                                 //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) searchFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate searchFailedWithError:results.error];
    [results release];
    return;
  }

  NSDictionary* response = (NSDictionary*)results.data;

  if ([[response objectForKey:@"success"] boolValue] == FALSE) {
    APIError* error = [[APIError alloc] initWithCode:0 message:[response objectForKey:@"error"]];
    [self._delegate searchFailedWithError:error];
    [error release];
    [results release];
    return;
  }

  int numResults = [[response objectForKey:@"numResults"] intValue];
  int execTimeMs = [[response objectForKey:@"execTimeMs"] intValue];

  NSMutableArray* postings = [[NSMutableArray alloc] init];
  for (NSDictionary* row in (NSDictionary*)[response objectForKey:@"results"]) {
    [postings addObject:[APIUtils dictionaryToPosting:row]];
  }

  [self._delegate gotSearchResults:postings timeTaken:execTimeMs numPostings:numResults];

  [postings release];
  [results  release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) rangeFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate rangeFailedWithError:results.error];
    [results release];
    return;
  }

  NSDictionary* response = (NSDictionary*)results.data;
  NSMutableDictionary* ranges = [[NSMutableDictionary alloc] init];
  for (NSString* field in [response keyEnumerator]) {
    NSDictionary* fieldResponse = [response objectForKey:field];
    NSObject* minValue = [fieldResponse objectForKey:@"min"];
    NSObject* maxValue = [fieldResponse objectForKey:@"max"];
    if (minValue == nil) {
      minValue = [NSNull null];
    }
    if (maxValue == nil) {
      maxValue = [NSNull null];
    }

    [ranges setObject:[NSArray arrayWithObjects:minValue, maxValue, nil]
               forKey:field];
  }

  [self._delegate calculatedRange:ranges];

  [ranges release];
  [results release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) summaryFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate summaryFailedWithError:results.error];
    [results release];
    return;
  }

  NSDictionary* response   = (NSDictionary*)results.data;
  NSDictionary* summary    = [response objectForKey:@"totals"];
  int           execTimeMs = [[response objectForKey:@"execTimeMs"] intValue];

  [self._delegate calculatedSummary:summary timeTaken:execTimeMs];

  [results release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) countFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate countFailedWithError:results.error];
    [results release];
    return;
  }

  NSDictionary* response = (NSDictionary*)results.data;
  int           numPosts = [[response objectForKey:@"count"] intValue];

  [self._delegate countReceived:numPosts];

  [results release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (NSMutableDictionary*) queryToDictionary:(SearchQuery*)query {

  NSMutableDictionary* queryDict = [[NSMutableDictionary alloc] init];

  if (query.source != nil) {
    [queryDict setObject:query.source forKey:@"source"];
  }
  if (query.category != nil) {
    [queryDict setObject:query.category forKey:@"category"];
  }
  if (query.location != nil) {
    [queryDict setObject:query.location forKey:@"location"];
  }
  if (query.heading != nil) {
    [queryDict setObject:query.heading forKey:@"heading"];
  }
  if (query.body != nil) {
    [queryDict setObject:query.body forKey:@"body"];
  }
  if (query.text != nil) {
    [queryDict setObject:query.text forKey:@"text"];
  }
  if (query.externalID != nil) {
    [queryDict setObject:query.externalID forKey:@"externalID"];
  }
  if (query.start != nil) {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'/'MM'/'dd' 'hh':'mm':'ss' UTC'"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [queryDict setObject:[formatter stringFromDate:query.start] forKey:@"start"];
    [formatter release];
  }
  if (query.end != nil) {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'/'MM'/'dd' 'hh':'mm':'ss' UTC'"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [queryDict setObject:[formatter stringFromDate:query.end] forKey:@"end"];
    [formatter release];
  }
  if ((query.annotations != nil) && ([query.annotations count] > 0)) {
    SBJsonWriter* writer = [[SBJsonWriter alloc] init];
    NSString* jsonData = [writer stringWithObject:query.annotations];
    [writer release];
    [queryDict setObject:jsonData forKey:@"annotations"];
  }
  if ((query.trustedAnnotations != nil) && ([query.trustedAnnotations count] > 0)) {
    SBJsonWriter* writer = [[SBJsonWriter alloc] init];
    NSString* jsonData = [writer stringWithObject:query.trustedAnnotations];
    [writer release];
    [queryDict setObject:jsonData forKey:@"trustedAnnotations"];
  }
  if (query.rpp != 0) {
    [queryDict setObject:[NSString stringWithFormat:@"%d", query.rpp] forKey:@"rpp"];
  }
  if (query.page != 0) {
    [queryDict setObject:[NSString stringWithFormat:@"%d", query.page] forKey:@"page"];
  }
  if ((query.retvals != nil) && ([query.retvals count] > 0)) {
    [queryDict setObject:[query.retvals componentsJoinedByString:@","]
                  forKey:@"retvals"];
  }

  return [queryDict autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################

@implementation SearchQuery

@synthesize source;
@synthesize category;
@synthesize location;
@synthesize heading;
@synthesize body;
@synthesize text;
@synthesize externalID;
@synthesize start;
@synthesize end;
@synthesize annotations;
@synthesize trustedAnnotations;
@synthesize rpp;
@synthesize page;
@synthesize retvals;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self.source             = nil;
    self.category           = nil;
    self.location           = nil;
    self.heading            = nil;
    self.body               = nil;
    self.text               = nil;
    self.externalID         = nil;
    self.start              = nil;
    self.end                = nil;
    self.annotations        = [[NSDictionary alloc] init];
    self.trustedAnnotations = [[NSDictionary alloc] init];
    self.rpp                = 0;
    self.page               = 0;
    self.retvals            = [NSArray arrayWithObjects:@"category", @"location", @"heading",
                                                        @"externalURL", @"timestamp", nil];

    [self.annotations        release]; // Don't over-retain our instance variables.
    [self.trustedAnnotations release];
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self.source             release];
  [self.category           release];
  [self.location           release];
  [self.heading            release];
  [self.body               release];
  [self.text               release];
  [self.externalID         release];
  [self.start              release];
  [self.end                release];
  [self.annotations        release];
  [self.trustedAnnotations release];
  [self.retvals            release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
