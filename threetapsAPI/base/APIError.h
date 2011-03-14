//  APIError.h
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

// ################################################################################################
//
// APIError
//
//     This generic class encapsulates a 3taps API error.

@interface APIError : NSObject {
  @public
  int       code;    // The numeric error code.
  NSString* message; // The human-readable error message.
}

@property (nonatomic, assign) int       code;
@property (nonatomic, retain) NSString* message;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// initWithCode:message:
//
//     Our designated initializer.

- (id) initWithCode:(int)errCode message:(NSString*)errMsg;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// dealloc
//
//     Release the memory used by our instance variables.

- (void) dealloc;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// description
//
//     Return a string describing this error.

- (NSString*) description;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
