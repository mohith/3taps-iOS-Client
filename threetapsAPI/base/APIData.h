//  APIData.h
//  threetapsAPI
//
//  Created by Erik Westra on 12/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

#import "APIConnection.h"

// ################################################################################################
//
// APIData
//
//     The |APIData| object encapsulates the data returned by a 3taps API call.   The data returned
//     by the API call is parsed using the JSON parser, and any errors (either within the API
//     connection itself, or with parsing the returned data) are kept track of.

@interface APIData : NSObject {
  @public
  BOOL      valid; // TRUE if and only if the api call returned valid JSON format data.
  APIError* error; // The error object, or |nil| if no error occurred.
  NSObject* data;  // The parsed data, or |nil| if an error occurred.
}

@property (nonatomic, assign) BOOL      valid;
@property (nonatomic, retain) APIError* error;
@property (nonatomic, retain) NSObject* data;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// initWithConnection:
//
//     Initialise a new |APIData| object.
//
//     The |APIData| object will attempt to load its contents from the given |APIConnection|.

- (id) initWithConnection:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// dealloc
//
//     Release the memory used by our instance variables.

- (void) dealloc;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
