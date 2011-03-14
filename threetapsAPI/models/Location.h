//  Location.h
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

// ################################################################################################
//
// Location
//
//     The |Location| class represents a location within the 3taps client APIs.
//
//     A |Location| object currently has the following attributes:
//
//         code
//
//             A three-letter code uniquely identifying this location.
//
//         countryRank
//
//             An integer used to sort the countries into a useful order (for example, to place the
//             United States at the top of the list of countries.
//
//         country
//
//             The name of the location's country, as a string.
//
//         stateCode
//
//             A brief (usually two-letter) code for the state or region this location is in.  This
//             will be |nil| for countries which do not have states or regions.
//
//         stateName
//
//             The name of the state or region this location is in.  This will be |nil| for
//             countries which do not have states or regions.
//
//         cityRank
//
//             An integer used to sort the cities within the country.
//
//         city
//
//             The name of the city within this country.
//
//         hidden
//
//             If TRUE, the location should be hidden in the system's user interface.
//
//         latitude
//
//             The latitude of this location, as a floating-point number representing decimal
//             degrees.
//
//         longitude
//
//             The longitude of this location, as a floating-point number representing decimal
//             degrees.
//
//     You can retrieve and change these attributes directly as required.
//
//     WARNING:
//
//            The structure of the |Location| object will change in the near future.

@interface Location : NSObject {
  @public
  NSString* code;
  NSNumber* countryRank;
  NSString* country;
  NSString* stateCode;
  NSString* stateName;
  NSNumber* cityRank;
  NSString* city;
  BOOL      hidden;
  NSNumber* latitude;
  NSNumber* longitude;
}

@property (nonatomic, retain) NSString* code;
@property (nonatomic, retain) NSNumber* countryRank;
@property (nonatomic, retain) NSString* country;
@property (nonatomic, retain) NSString* stateCode;
@property (nonatomic, retain) NSString* stateName;
@property (nonatomic, retain) NSNumber* cityRank;
@property (nonatomic, retain) NSString* city;
@property (nonatomic, assign) BOOL      hidden;
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
