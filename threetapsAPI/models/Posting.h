//  Posting.h
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

// ################################################################################################
//
// Posting
//
//     The |Posting| class represents a posting within the 3taps client APIs.
//
//     A |Posting| object has the following attributes:
//
//        postKey
//
//            A string uniqely identifying this posting in the 3taps system.
//
//        location
//
//            The code for the location to be associated with this posting, as a string.
//
//        category
//
//            The code for the category to be associated with this posting, as a string.
//
//        source
//
//            The code for the data source to be associated with this posting, as a string.
//
//        heading
//
//            A string representing a brief summary of the posting, up to 255 characters long.
//
//        body
//
//            A string containing the full text of the posting, up to 5,000 character long.
//
//        latitude
//
//            The latitude value associated with this posting, if any.  If this is given, it will
//            be a floating-point number representing the posting's latitude in decimal degrees.
//
//        longitude
//
//            The longitude value associated with this posting, if any.  If this is given, it will
//            be a floating-point number representing the posting's longitude in decimal degrees.
//
//        language
//
//            A two-character code identifying the language of the posting.  The value used here
//            should be a valid ISO 6943-1 language code.
//
//        price
//
//            The price to associate with this posting, as a floating-point number.
//
//        currency
//
//            A three-character code identifying which currency the price is in.  If supplied, this
//            must match one of the valid ISO 4217 currency codes.
//
//        images
//
//            An array of images to be associated with this posting.  Each array item will be the
//            URL of the image to display, as a string.
//
//        externalID
//
//            A string containing additional information that identifies this posting in some
//            external system.
//
//        externalURL
//
//            A string containing the URL that refers to this posting in some external system.
//
//        accountName
//
//            The name of the author of this posting in the originating system, if known.
//
//        accountID
//
//            The ID of the author in the originating system, as a string.  Note that in many cases
//            the account name and the account ID will be the same.
//
//        timestamp
//
//            An |NSDate| object representing the date and time at which this posting was made.
//            Note that the date and time will be in UTC.
//
//        expiration
//
//            An |NSDate| object representing the date and time at which this posting will expire,
//            if specified.  Note that the date and time will be in UTC.
//
//        annotations
//
//            An |NSDictionary| mapping annotation names to values for this posting's untrusted
//            annotations.
//
//        trustedAnnotations
//
//            An |NSDictionary| mapping annotation names to values for this posting's trusted
//            annotations.
//
//        clickCount
//
//            The number of times this posting has been clicked on in the 3taps system.
//
//     You can retrieve and change these attributes directly as required.

@interface Posting : NSObject {
  @public
  NSString*     postKey;
  NSString*     location;
  NSString*     category;
  NSString*     source;
  NSString*     heading;
  NSString*     body;
  NSNumber*     latitude;
  NSNumber*     longitude;
  NSString*     language;
  NSNumber*     price;
  NSString*     currency;
  NSArray*      images;
  NSString*     externalID;
  NSString*     externalURL;
  NSString*     accountName;
  NSString*     accountID;
  NSDate*       timestamp;
  NSDate*       expiration;
  NSDictionary* annotations;
  NSDictionary* trustedAnnotations;
  NSNumber*     clickCount;
}

@property (nonatomic, retain) NSString*     postKey;
@property (nonatomic, retain) NSString*     location;
@property (nonatomic, retain) NSString*     category;
@property (nonatomic, retain) NSString*     source;
@property (nonatomic, retain) NSString*     heading;
@property (nonatomic, retain) NSString*     body;
@property (nonatomic, retain) NSNumber*     latitude;
@property (nonatomic, retain) NSNumber*     longitude;
@property (nonatomic, retain) NSString*     language;
@property (nonatomic, retain) NSNumber*     price;
@property (nonatomic, retain) NSString*     currency;
@property (nonatomic, retain) NSArray*      images;
@property (nonatomic, retain) NSString*     externalID;
@property (nonatomic, retain) NSString*     externalURL;
@property (nonatomic, retain) NSString*     accountName;
@property (nonatomic, retain) NSString*     accountID;
@property (nonatomic, retain) NSDate*       timestamp;
@property (nonatomic, retain) NSDate*       expiration;
@property (nonatomic, retain) NSDictionary* annotations;
@property (nonatomic, retain) NSDictionary* trustedAnnotations;
@property (nonatomic, retain) NSNumber*     clickCount;

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
