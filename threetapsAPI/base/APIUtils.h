//  APIUtils.h
//  threetapsAPI
//
//  Created by Erik Westra on 15/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

#import "Posting.h"

// ################################################################################################
//
// APIUtils
//
//     This class provides various methods which can be called to perform utility functions.
//
//     Note that all the methods of |APIUtils| are class methods; this object is not intended to be
//     instantiated.

@interface APIUtils : NSObject {
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// convertToUTC:
//
//     Return the given NSDate object converted from local system time into UTC.

+ (NSDate*) convertToUTC:(NSDate*)sourceDate;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// convertFromUTC:
//
//     Return the given NSDate object converted from UTC back into local system time.

+ (NSDate*) convertFromUTC:(NSDate*)sourceDate;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// postingToDictionary:
//
//     Export the contents of a |Posting| object to a dictionary
//
//     We return an |NSDictionary| suitable for sending to the 3taps API.

+ (NSDictionary*) postingToDictionary:(Posting*)posting;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// dictionaryToPosting:
//
//     Create a new |Posting| object with the contents of the given dictionary.
//
//     We create and return a new |Posting| object based on the contents of the given
//     |NSDictionary| object.  The given dictionary should be in the form of the JSON data returned
//     by the 3taps Posting or Search APIs.

+ (Posting*) dictionaryToPosting:(NSDictionary*)postDict;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// stringToDate:
//
//     Convert a 3taps date/time string to an |NSDate| object.
//
//     Note that the returned |NSDate| object will be in UTC.

+ (NSDate*) stringToDate:(NSString*)string;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// dateToString:
//
//     Convert an |NSDate| object to a 3taps date/time string.
//
//     Note that |NSDate| should be in UTC.

+ (NSString*) dateToString:(NSDate*)date;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
