//  Location.m
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "Location.h"

// ################################################################################################

@implementation Location

@synthesize code;
@synthesize countryRank;
@synthesize country;
@synthesize stateCode;
@synthesize stateName;
@synthesize cityRank;
@synthesize city;
@synthesize hidden;
@synthesize latitude;
@synthesize longitude;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
     self.code        = nil;
     self.countryRank = nil;
     self.country     = nil;
     self.stateCode   = nil;
     self.stateName   = nil;
     self.cityRank    = nil;
     self.city        = nil;
     self.hidden      = FALSE;
     self.latitude    = nil;
     self.longitude   = nil;
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self.code        release];
  [self.countryRank release];
  [self.country     release];
  [self.stateCode   release];
  [self.stateName   release];
  [self.cityRank    release];
  [self.city        release];
  [self.latitude    release];
  [self.longitude   release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
