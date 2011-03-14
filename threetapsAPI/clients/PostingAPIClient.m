//  PostingAPIClient.m
//  threetapsAPI
//
//  Created by Erik Westra on 13/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "JSON.h"

#import "PostingAPIClient.h"

#import "APIConnection.h"
#import "APIData.h"
#import "APIError.h"
#import "APIUtils.h"

// ################################################################################################
//
// Private method definitions:

@interface PostingAPIClient (private)

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getFinishedWith:
//
//     Respond to our 'get' API call finishing or failing.

- (void) getFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// createFinishedWith:
//
//    Respond to our 'create' API call finishing or failing.

- (void) createFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// createManyFinishedWith:
//
//    Respond to our 'createMany' API call finishing or failing.

- (void) createManyFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// updateFinishedWith:
//
//    Respond to our 'update' API call finishing or failing.

- (void) updateFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// updateManyFinishedWith:
//
//    Respond to our 'updateMany' API call finishing or failing.

- (void) updateManyFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// deleteFinishedWith:
//
//    Respond to our 'delete' API call finishing or failing.

- (void) deleteFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// deleteManyFinishedWith:
//
//    Respond to our 'deleteMany' API call finishing or failing.

- (void) deleteManyFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################

@implementation PostingAPIClient

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

- (void) setDelegate:(<PostingAPIClientDelegate>)delegate {

  self._delegate = delegate;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) get:(NSString*)postKey {

  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:[NSString stringWithFormat:@"posting/get/%@", postKey]]];
  [connection setTarget:self
           withSelector:@selector(getFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];
  [connection release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) create:(Posting*)posting {

  NSMutableArray* data = [[NSMutableArray alloc] init];
  [data addObject:[APIUtils postingToDictionary:posting]];

  SBJsonWriter* writer = [[SBJsonWriter alloc] init];
  NSString* jsonData = [writer stringWithObject:data];
  [writer release];
  [data release];

  NSDictionary* args = [NSDictionary dictionaryWithObject:jsonData forKey:@"postings"];

  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"posting/create"]];
  [connection setFormValues:args];
  [connection setTarget:self
           withSelector:@selector(createFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];

  [connection release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) createMany:(NSArray*)postings {

  NSMutableArray* data = [[NSMutableArray alloc] init];
  for (Posting* posting in postings) {
    [data addObject:[APIUtils postingToDictionary:posting]];
  }

  SBJsonWriter* writer = [[SBJsonWriter alloc] init];
  NSString* jsonData = [writer stringWithObject:data];
  [writer release];
  [data release];

  NSDictionary* args = [NSDictionary dictionaryWithObject:jsonData forKey:@"postings"];

  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"posting/create"]];
  [connection setFormValues:args];
  [connection setTarget:self
           withSelector:@selector(createManyFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];

  [connection release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) update:(Posting*)posting {

  NSMutableArray* data = [[NSMutableArray alloc] init];
  NSDictionary* postDict = [APIUtils postingToDictionary:posting];
  if ([postDict objectForKey:@"postKey"] != nil) {
    NSString* postKey = [postDict objectForKey:@"postKey"];
    NSMutableDictionary* newPostDict = [[NSMutableDictionary alloc] init];
    [newPostDict addEntriesFromDictionary:postDict];
    [newPostDict removeObjectForKey:@"postKey"];

    [data addObject:[NSArray arrayWithObjects:postKey, newPostDict, nil]];
    [newPostDict release];
  }

  SBJsonWriter* writer = [[SBJsonWriter alloc] init];
  NSString* jsonData = [writer stringWithObject:data];
  [writer release];
  [data release];

  NSDictionary* args = [NSDictionary dictionaryWithObject:jsonData forKey:@"data"];

  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"posting/update"]];
  [connection setFormValues:args];
  [connection setTarget:self
           withSelector:@selector(updateFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];

  [connection release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) updateMany:(NSArray*)postings {

  NSMutableArray* data = [[NSMutableArray alloc] init];
  for (Posting* posting in postings) {
    NSDictionary* postDict = [APIUtils postingToDictionary:posting];
    if ([postDict objectForKey:@"postKey"] != nil) {
      NSString* postKey = [postDict objectForKey:@"postKey"];
      NSMutableDictionary* newPostDict = [[NSMutableDictionary alloc] init];
      [newPostDict addEntriesFromDictionary:postDict];
      [newPostDict removeObjectForKey:@"postKey"];

      [data addObject:[NSArray arrayWithObjects:postKey, newPostDict, nil]];
      [newPostDict release];
    }
  }

  SBJsonWriter* writer = [[SBJsonWriter alloc] init];
  NSString* jsonData = [writer stringWithObject:data];
  [writer release];
  [data release];

  NSDictionary* args = [NSDictionary dictionaryWithObject:jsonData forKey:@"data"];

  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"posting/update"]];
  [connection setFormValues:args];
  [connection setTarget:self
           withSelector:@selector(updateManyFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];

  [connection release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) delete:(NSString*)postKey {

  NSMutableArray* data = [[NSMutableArray alloc] init];
  [data addObject:postKey];

  SBJsonWriter* writer = [[SBJsonWriter alloc] init];
  NSString* jsonData = [writer stringWithObject:data];
  [writer release];
  [data release];

  NSDictionary* args = [NSDictionary dictionaryWithObject:jsonData forKey:@"data"];

  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"posting/delete"]];
  [connection setFormValues:args];
  [connection setTarget:self
           withSelector:@selector(deleteFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];

  [connection release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) deleteMany:(NSArray*)postKeys {

  NSMutableArray* data = [[NSMutableArray alloc] init];
  for (NSString* postKey in postKeys) {
    [data addObject:postKey];
  }

  SBJsonWriter* writer = [[SBJsonWriter alloc] init];
  NSString* jsonData = [writer stringWithObject:data];
  [writer release];
  [data release];

  NSDictionary* args = [NSDictionary dictionaryWithObject:jsonData forKey:@"data"];

  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"posting/delete"]];
  [connection setFormValues:args];
  [connection setTarget:self
           withSelector:@selector(deleteManyFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];

  [connection release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                 P R I V A T E   M E T H O D S                                 //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate getFailedWithError:results.error];
    [results release];
    return;
  }

  NSDictionary* postDict = (NSDictionary*)results.data;

  if (([postDict objectForKey:@"code"] != nil) && ([postDict objectForKey:@"message"] != nil)) {
    // We received an error object rather than the desired posting -> posting doesn't exist.
    APIError* error = [[APIError alloc] initWithCode:[[postDict objectForKey:@"code"] intValue]
                                             message:[postDict objectForKey:@"message"]];
    [self._delegate getFailedWithError:error];
    [error release];
    [results release];
    return;
  }

  Posting* posting = [APIUtils dictionaryToPosting:postDict];
  [self._delegate getFinished:posting];
  
  [results release];
  [postDict release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) createFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate createFailedWithError:results.error];
    [results release];
    return;
  }

  NSMutableArray* responses = [[NSMutableArray alloc] init];
  for (NSDictionary* row in (NSDictionary*)results.data) {
    CreatePostingResult* response = [[CreatePostingResult alloc] init];

    if ([row objectForKey:@"error"] == nil) {
      response.accepted = TRUE;
      response.postKey  = [row objectForKey:@"postKey"];
    } else {
      response.accepted     = FALSE;
      response.errorCode    = [[[row objectForKey:@"error"] objectForKey:@"code"] intValue];
      response.errorMessage = [[row objectForKey:@"error"] objectForKey:@"message"];
    }

    [responses addObject:response];
    [response release];
  }

  [self._delegate createFinished:[responses objectAtIndex:0]];

  [responses release];
  [results   release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) createManyFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate createManyFailedWithError:results.error];
    [results release];
    return;
  }

  NSMutableArray* responses = [[NSMutableArray alloc] init];
  for (NSDictionary* row in (NSDictionary*)results.data) {
    CreatePostingResult* response = [[CreatePostingResult alloc] init];

    if ([row objectForKey:@"error"] == nil) {
      response.accepted = TRUE;
      response.postKey  = [row objectForKey:@"postKey"];
    } else {
      response.accepted     = FALSE;
      response.errorCode    = [[[row objectForKey:@"error"] objectForKey:@"code"] intValue];
      response.errorMessage = [[row objectForKey:@"error"] objectForKey:@"message"];
    }

    [responses addObject:response];
    [response release];
  }

  [self._delegate createManyFinished:responses];

  [responses release];
  [results   release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) updateFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate updateFailedWithError:results.error];
    [results release];
    return;
  }

  NSDictionary* response = (NSDictionary*)results.data;
  BOOL success = [[response objectForKey:@"success"] boolValue];

  [self._delegate updateFinished:success];

  [results release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) updateManyFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate updateManyFailedWithError:results.error];
    [results release];
    return;
  }

  NSDictionary* response = (NSDictionary*)results.data;
  BOOL success = [[response objectForKey:@"success"] boolValue];

  [self._delegate updateManyFinished:success];

  [results release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) deleteFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate deleteFailedWithError:results.error];
    [results release];
    return;
  }

  NSDictionary* response = (NSDictionary*)results.data;
  BOOL success = [[response objectForKey:@"success"] boolValue];

  [self._delegate deleteFinished:success];

  [results release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) deleteManyFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate deleteManyFailedWithError:results.error];
    [results release];
    return;
  }

  NSDictionary* response = (NSDictionary*)results.data;
  BOOL success = [[response objectForKey:@"success"] boolValue];

  [self._delegate deleteManyFinished:success];

  [results release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################

@implementation CreatePostingResult

@synthesize accepted;
@synthesize postKey;
@synthesize errorCode;
@synthesize errorMessage;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self.accepted     = FALSE;
    self.postKey      = nil;
    self.errorCode    = 0;
    self.errorMessage = nil;
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self.postKey      release];
  [self.errorMessage release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
