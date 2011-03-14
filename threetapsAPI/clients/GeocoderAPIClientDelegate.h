//  GeocoderAPIClientDelegate.h
//  threetapsAPI
//
//  Created by Erik Westra on 13/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <UIKit/UIKit.h>

#import "APIError.h"

// ################################################################################################
//
// GeocoderAPIClientDelegate
//
//     This formal protocol defines the methods which a |GeocoderAPIClient| delegate object must
//     implement in order to respond to a completed Geocoder API call.
//
//     Note that while all the methods of this protocol are optional, an |NSException| will be
//     raised if an API call is made and the required delegate method has not been implemented.

@protocol GeocoderAPIClientDelegate <NSObject>

@optional

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// geocodeFinished:
//
//     Respond to a |geocode| API call successfully finishing.
//
//     'responses' will be an |NSArray| of GeocodeResponse objects containing the results of the
//     geocoding attempt.  There will be one entry in the 'responses' list for each entry in the
//     'requests' array passed to [GeocoderAPIClient geocode:].

- (void) geocodeFinished:(NSArray*)responses;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// geocodeFailedWithError:
//
//     Respond to an error occurring while performing the |geocode| API call.

- (void) geocodeFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
