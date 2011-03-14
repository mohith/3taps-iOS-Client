//  AllTests.m
//  threetapsAPI
//
//  Created by Erik Westra on 12/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "AllTests.h"

// ################################################################################################
//
// Private method definitions:

@interface AllTests (private)

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// geocoderAPIClientTestsFinished
//
//     Respond the our GeocoderAPIClientTester finishing its unit tests.
//
//     We start running the tests for the next API client tester.

- (void) geocoderAPIClientTestsFinished;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// postingAPIClientTestsFinished
//
//     Respond the our PostingAPIClientTester finishing its unit tests.
//
//     We start running the tests for the next API client tester.

- (void) postingAPIClientTestsFinished;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// referenceAPIClientTestsFinished
//
//     Respond the our ReferenceAPIClientTester finishing its unit tests.
//
//     We start running the tests for the next API client tester.

- (void) referenceAPIClientTestsFinished;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// searchAPIClientTestsFinished
//
//     Respond the our SearchAPIClientTester finishing its unit tests.
//
//     We start running the tests for the next API client tester.

- (void) searchAPIClientTestsFinished;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// statusAPIClientTestsFinished
//
//     Respond the our StatusAPIClientTester finishing its unit tests.
//
//     We stop running our tests, since this is the last API tester we have to run.

- (void) statusAPIClientTestsFinished;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################

@implementation AllTests

@synthesize _geocoderAPIClientTester;
@synthesize _postingAPIClientTester;
@synthesize _referenceAPIClientTester;
@synthesize _searchAPIClientTester;
@synthesize _statusAPIClientTester;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self._geocoderAPIClientTester  = [[GeocoderAPIClientTester  alloc] init];
    self._postingAPIClientTester   = [[PostingAPIClientTester   alloc] init];
    self._referenceAPIClientTester = [[ReferenceAPIClientTester alloc] init];
    self._searchAPIClientTester    = [[SearchAPIClientTester    alloc] init];
    self._statusAPIClientTester    = [[StatusAPIClientTester    alloc] init];

    [self._geocoderAPIClientTester  release]; // Don't over-retain our instance variables.
    [self._postingAPIClientTester   release];
    [self._referenceAPIClientTester release];
    [self._searchAPIClientTester    release];
    [self._statusAPIClientTester    release];
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self._geocoderAPIClientTester  release];
  [self._postingAPIClientTester   release];
  [self._referenceAPIClientTester release];
  [self._searchAPIClientTester    release];
  [self._statusAPIClientTester    release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) run {

  NSLog(@"Running unit tests for threetapsAPI library...");
  [self._geocoderAPIClientTester
   runWithCompletionTarget:self
                  selector:@selector(geocoderAPIClientTestsFinished)];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                 P R I V A T E   M E T H O D S                                 //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) geocoderAPIClientTestsFinished {

  [self._postingAPIClientTester
   runWithCompletionTarget:self
                  selector:@selector(postingAPIClientTestsFinished)];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) postingAPIClientTestsFinished {

  [self._referenceAPIClientTester
   runWithCompletionTarget:self
                  selector:@selector(referenceAPIClientTestsFinished)];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) referenceAPIClientTestsFinished {

  [self._searchAPIClientTester
   runWithCompletionTarget:self
                  selector:@selector(searchAPIClientTestsFinished)];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) searchAPIClientTestsFinished {

  [self._statusAPIClientTester
   runWithCompletionTarget:self
                  selector:@selector(statusAPIClientTestsFinished)];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) statusAPIClientTestsFinished {

  NSLog(@"All unit tests finished");
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
