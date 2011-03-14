//  GeocoderAPIClient.h
//  threetapsAPI
//
//  Created by Erik Westra on 13/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

#import "APIClient.h"
#import "GeocoderAPIClientDelegate.h"

// ################################################################################################
//
// GeocoderAPIClient
//
//     This 3taps API client provides asynchronous access to the 3taps Geocoder API.

@interface GeocoderAPIClient : APIClient {

  @private
  <GeocoderAPIClientDelegate> _delegate;
}

@property (nonatomic, retain) <GeocoderAPIClientDelegate> _delegate;

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
//     Set our |GeocoderAPIClientDelegate| object.
//
//     Our delegate object will respond when Geocoder API calls have been completed.

- (void) setDelegate:(<GeocoderAPIClientDelegate>)delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// geocode:
//
//     Ask the geocoder to geocode one or more postings.
//
//     'requests' should be an array of |GeocodeRequest| objects containing the location
//     information for one or more postings.  Upon completion, one of the following delegate
//     methods will be called as appropriate:
//
//         geocodeFinished:
//         geocodeFailedWithError:

- (void) geocode:(NSArray*)requests;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################
//
// GeocodeRequest
//
//     The |GeocodeRequest| object encapsulates a single geocoding request to the 3taps server.
//
//     A GeocoderRequest object has the following attributes:
//
//         latitude
//
//             The latitude of the posting, as a floating-point number in decimal degrees.
//
//         longitude
//
//             The longitude of the posting, as a floating-point number in decimal degrees.
//
//         country
//
//             The name of the country.
//
//         state
//
//             The name or code for the state or region.
//
//         city
//
//             The name of the city.
//
//         locality
//
//             The name of a suburb, area or town within the specified city.
//
//         street
//
//             The full street address for this location.
//
//         postal
//
//             The ZIP or postal code for this location.
//
//         text
//
//             Freeform text holding a location name or address value.
//
//     You can retrieve and change these attributes directly as required.

@interface GeocodeRequest : NSObject {
  @public
  NSNumber* latitude;
  NSNumber* longitude;
  NSString* country;
  NSString* state;
  NSString* city;
  NSString* locality;
  NSString* street;
  NSString* postal;
  NSString* text;
}

@property (nonatomic, retain) NSNumber* latitude;
@property (nonatomic, retain) NSNumber* longitude;
@property (nonatomic, retain) NSString* country;
@property (nonatomic, retain) NSString* state;
@property (nonatomic, retain) NSString* city;
@property (nonatomic, retain) NSString* locality;
@property (nonatomic, retain) NSString* street;
@property (nonatomic, retain) NSString* postal;
@property (nonatomic, retain) NSString* text;

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

// ################################################################################################
//
// GeocodeResponse
//
//     The |GeocodeResponse| object encapsulates a single geocoding response from the 3taps server.
//
//     A GeocoderResponse object has the following attributes:
//
//         code
//
//             The 3taps location code for this posting, or |nil| if the posting could not be
//             geocoded.
//
//         latitude
//
//             The calculated latitude of the posting, as a floating-point number in decimal
//             degrees.  This will be set to |nil| if the latitude of the posting could not be
//             calculated.
//
//         longitude
//
//             The calculated longitude of the posting, as a floating-point number in decimal
//             degrees.  This will be set to |nil| if the longitude of the posting could not be
//             calculated.
//
//     You can retrieve and change these attributes directly as required.

@interface GeocodeResponse : NSObject {
  @public
  NSString* code;
  NSNumber* latitude;
  NSNumber* longitude;
}

@property (nonatomic, retain) NSString* code;
@property (nonatomic, retain) NSNumber* latitude;
@property (nonatomic, retain) NSNumber* longitude;

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
