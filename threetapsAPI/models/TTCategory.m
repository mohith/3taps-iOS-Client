//  Category.m
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "TTCategory.h"

// ################################################################################################

@implementation TTCategory

@synthesize code;
@synthesize group;
@synthesize name;
@synthesize annotations;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self.code        = nil;
    self.group       = nil;
    self.name        = nil;
    self.annotations = [[NSArray alloc] init];

    [self.annotations release]; // Don't over-retain our instance variables.
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self.code        release];
  [self.group       release];
  [self.name        release];
  [self.annotations release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
