//  PostingAPIClientTester.m
//  threetapsAPI
//
//  Created by Erik Westra on 12/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "PostingAPIClientTester.h"

#import "APIUtils.h"

// ################################################################################################
//
// Private method definitions:

@interface PostingAPIClientTester (private)

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testCreate
//
//     Test the [PostingAPIClient create:] method.

- (void) testCreate;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testUpdate
//
//     Test the [PostingAPIClient update:] method.

- (void) testUpdate;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testGet
//
//     Test the [PostingAPIClient get:] method.

- (void) testGet;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testDelete
//
//     Test the [PostingAPIClient delete:] method.

- (void) testDelete;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testCreateMany
//
//     Test the [PostingAPIClient createMany:] method.

- (void) testCreateMany;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testUpdateMany
//
//     Test the [PostingAPIClient updateMany:] method.

- (void) testUpdateMany;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testDeleteMany
//
//     Test the [PostingAPIClient deleteMany:] method.

- (void) testDeleteMany;

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

@implementation PostingAPIClientTester

@synthesize _client;
@synthesize _target;
@synthesize _selector;
@synthesize _postKeys;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self._client = [[PostingAPIClient alloc] init];
    [self._client setDelegate:self];

    self._target   = nil;
    self._selector = nil;
    self._postKeys = nil;

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

  [self testCreate];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//              R E F E R E N C E A P I C L I E N T D E L E G A T E   M E T H O D S              //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) createFinished:(CreatePostingResult*)result {

  if (result.accepted) {
    NSLog(@"[PostingAPIClient create:] successfully finished, postkey = %@", result.postKey);
    self._postKeys = [NSArray arrayWithObject:result.postKey];
    [self testUpdate];
  } else {
    NSLog(@"[PostingAPIClient create:] succeeded but posting rejected, error = %d %@",
          result.errorCode, result.errorMessage);
    [self testsFinished];
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) createFailedWithError:(APIError*)error {

  NSLog(@"[PostingAPIClient create:] failed: %@", [error description]);
  [self testsFinished];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) updateFinished:(BOOL)success {

  NSLog(@"[PostingAPIClient update:] finished, success = %d", (int)success);
  [self testGet];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) updateFailedWithError:(APIError*)error {
  NSLog(@"[PostingAPIClient update:] failed: %@", [error description]);
  [self testGet];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getFinished:(Posting*)posting {

  NSLog(@"[PostingAPIClient get:] finished, posting.postKey = %@", posting.postKey);
  [self testDelete];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getFailedWithError:(APIError*)error {

  NSLog(@"[PostingAPIClient get:] failed: %@", [error description]);
  NSLog(@"(It's normal for the posting not to be available yet).");
  [self testDelete];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) deleteFinished:(BOOL)success {

  NSLog(@"[PostingAPIClient delete:] finished, success = %d", (int)success);
  [self testCreateMany];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) deleteFailedWithError:(APIError*)error {

  NSLog(@"[PostingAPIClient delete:] failed: %@", [error description]);
  [self testCreateMany];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) createManyFinished:(NSArray*)results {

  NSMutableArray* postKeys = [[NSMutableArray alloc] init];

  NSLog(@"[PostingAPIClient createMany:] finished, creation results:");
  for (CreatePostingResult* result in results) {
    if (result.accepted) {
      NSLog(@"   posting accepted, postkey = %@", result.postKey);
      [postKeys addObject:result.postKey];
    } else {
      NSLog(@"   posting rejected, error = %d %@", result.errorCode, result.errorMessage);
    }
  }

  if ([postKeys count] > 0) {
    self._postKeys = postKeys;
    [self testUpdateMany];
  } else {
    [postKeys release];
    [self testsFinished];
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) createManyFailedWithError:(APIError*)error {

  NSLog(@"[PostingAPIClient createMany:] failed: %@", [error description]);
  [self testsFinished];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) updateManyFinished:(BOOL)success {

  NSLog(@"[PostingAPIClient updateMany:] finished, success = %d", (int)success);
  [self testDeleteMany];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) updateManyFailedWithError:(APIError*)error {

  NSLog(@"[PostingAPIClient updateMany:] failed: %@", [error description]);
  [self testDeleteMany];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) deleteManyFinished:(BOOL)success {

  NSLog(@"[PostingAPIClient deleteMany:] finished, success = %d", (int)success);
  [self testsFinished];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) deleteManyFailedWithError:(APIError*)error {

  NSLog(@"[PostingAPIClient deleteMany:] failed: %@", [error description]);
  [self testsFinished];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                 P R I V A T E   M E T H O D S                                 //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testCreate {

  NSLog(@"Testing [PostingAPIClient create:] API call...");

  int curSecs = (int)[[NSDate date] timeIntervalSince1970];

  Posting* posting   = [[Posting alloc] init];
  posting.location   = @"SFO";
  posting.source     = @"CRAIG";
  posting.heading    = @"Test Post";
  posting.externalID = [NSString stringWithFormat:@"TEST%d", curSecs];
  posting.timestamp  = [APIUtils convertToUTC:[NSDate date]];

  [self._client create:posting];
  [posting release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testUpdate {

  NSLog(@"Testing [PostingAPIClient update:] API call...");

  NSString* postKey = [self._postKeys objectAtIndex:0];

  Posting* posting = [[Posting alloc] init];
  posting.postKey = postKey;
  posting.body = @"Body of test post";

  [self._client update:posting];
  [posting release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testGet {

  NSLog(@"Testing [PostingAPIClient get:] API call...");

  NSString* postKey = [self._postKeys objectAtIndex:0];
  NSLog(@"postKey = %@", postKey);
  [self._client get:postKey];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testDelete {

  NSLog(@"Testing [PostingAPIClient delete:] API call...");

  NSString* postKey = [self._postKeys objectAtIndex:0];
  [self._client delete:postKey];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testCreateMany {

  NSLog(@"Testing [PostingAPIClient createMany:] API call...");

  int curSecs = (int)[[NSDate date] timeIntervalSince1970];

  Posting* posting1 = [[Posting alloc] init];
  posting1.location   = @"SFO";
  posting1.source     = @"CRAIG";
  posting1.heading    = @"Test Post 1";
  posting1.externalID = [NSString stringWithFormat:@"TEST%d", curSecs];
  posting1.timestamp  = [APIUtils convertToUTC:[NSDate date]];

  Posting* posting2 = [[Posting alloc] init];
  posting2.location   = @"SFO";
  posting2.source     = @"CRAIG";
  posting2.heading    = @"Test Post 2";
  posting2.externalID = [NSString stringWithFormat:@"TEST%d", curSecs+1];
  posting2.timestamp  = [APIUtils convertToUTC:[NSDate date]];

  NSArray* postings = [[NSArray alloc] initWithObjects:posting1, posting2, nil];

  [self._client createMany:postings];
  [postings release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testUpdateMany {

  NSLog(@"Testing [PostingAPIClient updateMany:] API call...");

  Posting* posting1 = [[Posting alloc] init];
  posting1.postKey = [self._postKeys objectAtIndex:0];
  posting1.body    = @"Body of test post 1";

  Posting* posting2 = [[Posting alloc] init];
  posting2.postKey = [self._postKeys objectAtIndex:1];
  posting2.body    = @"Body of test post 2";

  NSArray* postings = [[NSArray alloc] initWithObjects:posting1, posting2, nil];

  [self._client updateMany:postings];
  [postings release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testDeleteMany {

  NSLog(@"Testing [PostingAPIClient deleteMany:] API call...");

  [self._client deleteMany:self._postKeys];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testsFinished {

  [self._target performSelector:self._selector];
}

//////////////////////////////////////////////////////////////////////////////////////////////////

@end
