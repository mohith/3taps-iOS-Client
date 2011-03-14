//  GeocoderAPIClientTester.m
//  threetapsAPI
//
//  Created by Erik Westra on 12/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "GeocoderAPIClientTester.h"

// ################################################################################################
//
// Private method definitions:

@interface GeocoderAPIClientTester (private)

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testGeocode
//
//     Test the [GeocoderAPIClient geocode] method.
//
//     Note that this is a pretty basic test right now; we should add more comprehensive testing
//     logic later.

- (void) testGeocode;

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

@implementation GeocoderAPIClientTester

@synthesize _client;
@synthesize _target;
@synthesize _selector;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self._client = [[GeocoderAPIClient alloc] init];
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

  [self testGeocode];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//              R E F E R E N C E A P I C L I E N T D E L E G A T E   M E T H O D S              //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) geocodeFinished:(NSArray*)responses {

  GeocodeResponse* response = [responses objectAtIndex:0];
  NSLog(@"[GeocoderAPIClient geocode] successfully finished, code = %@, lat=%@, long=%@",
        response.code, response.latitude, response.longitude);

  [self testsFinished];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) geocodeFailedWithError:(APIError*)error {

  NSLog(@"[GeocoderAPIClient geocode] failed: %@", [error description]);

  [self testsFinished];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                 P R I V A T E   M E T H O D S                                 //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testGeocode {

  NSLog(@"Testing [GeocoderAPIClient geocode] API call...");

  GeocodeRequest* request = [[GeocodeRequest alloc] init];
  request.country  = @"United States";
  request.state    = @"California";
  request.city     = @"San Francisco";
  request.locality = @"Sausalito";
  request.street   = @"66 Starbuck Drive, Muir Beach";
  [self._client geocode:[NSArray arrayWithObject:request]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testsFinished {

  [self._target performSelector:self._selector];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
