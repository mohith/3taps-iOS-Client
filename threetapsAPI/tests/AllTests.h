//  AllTests.h
//  threetapsAPI
//
//  Created by Erik Westra on 12/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

#import "GeocoderAPIClientTester.h"
#import "PostingAPIClientTester.h"
#import "ReferenceAPIClientTester.h"
#import "SearchAPIClientTester.h"
#import "StatusAPIClientTester.h"

// ################################################################################################
//
// AllTests
//
//    This class encapsulates the logic of running the various API client testers, one after the
//    other.
//
//    To run the tests, simply create an instance of the |AllTests| object and call its 'run'
//    method.  The various unit tests will be run asynchronously, one after the other, with the
//    results written to the console log.

@interface AllTests : NSObject {
  @private
  GeocoderAPIClientTester*  _geocoderAPIClientTester;  // Tester for the Geocoder API client.
  PostingAPIClientTester*   _postingAPIClientTester;   // Tester for the Posting API client.
  ReferenceAPIClientTester* _referenceAPIClientTester; // Tester for the Reference API client.
  SearchAPIClientTester*    _searchAPIClientTester;    // Tester for the Search API client.
  StatusAPIClientTester*    _statusAPIClientTester;    // Tester for the Status API client.
}

@property (nonatomic, retain) GeocoderAPIClientTester*  _geocoderAPIClientTester;
@property (nonatomic, retain) PostingAPIClientTester*   _postingAPIClientTester;
@property (nonatomic, retain) ReferenceAPIClientTester* _referenceAPIClientTester;
@property (nonatomic, retain) SearchAPIClientTester*    _searchAPIClientTester;
@property (nonatomic, retain) StatusAPIClientTester*    _statusAPIClientTester;

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
// run
//
//     Run the unit tests, one after the other.

- (void) run;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
