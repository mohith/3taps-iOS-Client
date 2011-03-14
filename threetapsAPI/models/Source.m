//  Source.m
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "Source.h"

// ################################################################################################

@implementation Source

@synthesize name;
@synthesize code;
@synthesize logoURL;
@synthesize smallLogoURL;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self.name         = nil;
    self.code         = nil;
    self.logoURL      = nil;
    self.smallLogoURL = nil;
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self.name         release];
  [self.code         release];
  [self.logoURL      release];
  [self.smallLogoURL release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
