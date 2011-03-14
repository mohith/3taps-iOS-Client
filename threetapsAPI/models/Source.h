//  Source.h
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

// ################################################################################################
//
// Source
//
//     The |Source| class represents a data source within the 3taps client APIs.
//
//     A |Source| object has the following attributes:
//
//         name
//
//             The name of the data source, as a string.
//
//         code
//
//             A brief string uniquely identifying this data source.
//
//         logoURL
//
//             The URL used to access this data source's logo, as a string.
//
//         smallLogoURL
//
//             The URL used to access the small version of this data source's logo, as a string.
//
//     You can retrieve and change these attributes directly as required.

@interface Source : NSObject {
  @public
  NSString*     name;
  NSString*     code;
  NSString*     logoURL;
  NSString*     smallLogoURL;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* code;
@property (nonatomic, retain) NSString* logoURL;
@property (nonatomic, retain) NSString* smallLogoURL;

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
