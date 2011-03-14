//  StatusAPIClientTester.m
//  threetapsAPI
//
//  Created by Erik Westra on 12/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "StatusAPIClientTester.h"

#import "APIUtils.h"

// ################################################################################################
//
// Private method definitions:

@interface StatusAPIClientTester (private)

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testUpdate
//
//     Test the [StatusAPIClient updateStatus] method.

- (void) testUpdate;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testGet
//
//     Test the [StatusAPIClient getStatusHistory] method.

- (void) testGet;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testSystem
//
//     Test the [StatusAPIClient getSystemStatus] method.

- (void) testSystem;

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

@implementation StatusAPIClientTester

@synthesize _client;
@synthesize _target;
@synthesize _selector;
@synthesize _externalID;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self._client = [[StatusAPIClient alloc] init];
    [self._client setDelegate:self];

    self._target     = nil;
    self._selector   = nil;
    self._externalID = nil;

    [self._client release]; // Don't over-retain our instance variables.
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self._client     release];
  [self._target     release];
  [self._externalID release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) runWithCompletionTarget:(NSObject*)target selector:(SEL)selector {

  self._target   = target;
  self._selector = selector;

  [self testUpdate];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//              R E F E R E N C E A P I C L I E N T D E L E G A T E   M E T H O D S              //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) statusUpdated {

  NSLog(@"[StatusAPIClient updateStatus:] successfully finished");
  [self testGet];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) statusUpdateFailedWithError:(APIError*)error {

  NSLog(@"[StatusAPIClient updateStatus:] failed: %@", [error description]);
  [self testGet];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) gotStatusHistory:(NSArray*)history {

  NSLog(@"[StatusAPIClient getStatusHistory:] succeeded, history = %@", history);
  [self testSystem];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getStatusHistoryFailedWithError:(APIError*)error {

  NSLog(@"[StatusAPIClient getStatusHistory:] failed: %@", [error description]);
  [self testSystem];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) gotSystemStatusCode:(int)code message:(NSString*)message {

  NSLog(@"[StatusAPIClient getSystemStatus] succeeded, status = %d %@", code, message);
  [self testsFinished];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getSystemStatusFailedWithError:(APIError*)error {

  NSLog(@"[StatusAPIClient getSystemStatus] failed: %@", [error description]);
  [self testsFinished];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                 P R I V A T E   M E T H O D S                                 //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testUpdate {

  NSLog(@"Testing [StatusAPIClient updateStatus:] API call...");

  int curSecs = (int)[[NSDate date] timeIntervalSince1970];
  self._externalID = [NSString stringWithFormat:@"TEST%d", curSecs];

  StatusUpdate* update = [[StatusUpdate alloc] init];
  update.status     = StatusUpdateStatusFound;
  update.externalID = self._externalID;
  update.source     = @"CRAIG";
  update.timestamp  = [APIUtils convertToUTC:[NSDate date]];

  NSArray* updates = [NSArray arrayWithObject:update];

  [self._client updateStatus:updates];

  [update release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testGet {

  NSLog(@"Testing [StatusAPIClient getStatusHistory:] API call...");

  Posting* posting = [[Posting alloc] init];
  posting.externalID = self._externalID;
  posting.source     = @"CRAIG";

  NSArray* postings = [NSArray arrayWithObject:posting];

  [self._client getStatusHistory:postings];

  [posting release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testSystem {

  NSLog(@"Testing [StatusAPIClient getSystemStatus] API call...");

  [self._client getSystemStatus];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testsFinished {

  [self._target performSelector:self._selector];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
