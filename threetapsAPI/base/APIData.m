//  APIResultParser.m
//  threetapsAPI
//
//  Created by Erik Westra on 12/03/11.
//  Copyright (c) 2011. 3taps inc.  All rights reserved.

#import "APIData.h"

#import "JSON.h"

// ################################################################################################

@implementation APIData

@synthesize valid;
@synthesize error;
@synthesize data;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) initWithConnection:(APIConnection*)connection {

  if (self = [super init]) {
    if ([connection getStatus] == APIConnectionStatusFailed) {
      self.valid = FALSE;
      self.error = [connection getError];
      self.data  = nil;
    } else if ([connection getStatus] != APIConnectionStatusFinished) {
      // Should never happen.
      self.valid = FALSE;
      self.error = [[APIError alloc] initWithCode:-1 message:@"API connection not finished!"];
      self.data  = nil;
    } else {
      // Attempt to parse the data returned by the server.
      NSString* response = [[NSString alloc] initWithData:[connection getData]
                                                 encoding:NSUTF8StringEncoding];

      SBJSON*   parser       = [[SBJSON alloc] init];
      NSError*  parsingError = nil;

      NSObject* parsedData = [parser objectWithString:response error:&parsingError];

      [response release];
      [parser   release];

      if (parsingError != nil) {
        self.valid = FALSE;
        self.error = [[APIError alloc] initWithCode:parsingError.code
                                            message:[parsingError localizedDescription]];
        self.data  = nil;
      } else {
        self.valid = TRUE;
        self.error = nil;
        self.data  = parsedData;
      }
    }
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self.error release];
  [self.data  release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
