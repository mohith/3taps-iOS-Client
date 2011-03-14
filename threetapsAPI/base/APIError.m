//  APIError.m
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "APIError.h"

// ################################################################################################

@implementation APIError

@synthesize code;
@synthesize message;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) initWithCode:(int)errCode message:(NSString*)errMsg {

  if (self = [super init]) {
    self.code    = errCode;
    self.message = errMsg;
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self.message release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString*) description {

  return [NSString stringWithFormat:@"<APIError %d, %@>", self.code, self.message];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
