//  Posting.m
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "Posting.h"

// ################################################################################################

@implementation Posting

@synthesize postKey;
@synthesize location;
@synthesize category;
@synthesize source;
@synthesize heading;
@synthesize body;
@synthesize latitude;
@synthesize longitude;
@synthesize language;
@synthesize price;
@synthesize currency;
@synthesize images;
@synthesize externalID;
@synthesize externalURL;
@synthesize accountName;
@synthesize accountID;
@synthesize timestamp;
@synthesize expiration;
@synthesize annotations;
@synthesize trustedAnnotations;
@synthesize clickCount;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self.postKey            = nil;
    self.location           = nil;
    self.category           = nil;
    self.source             = nil;
    self.heading            = nil;
    self.body               = nil;
    self.latitude           = nil;
    self.longitude          = nil;
    self.language           = nil;
    self.price              = nil;
    self.currency           = nil;
    self.images             = [[NSArray alloc] init];
    self.externalID         = nil;
    self.externalURL        = nil;
    self.accountName        = nil;
    self.accountID          = nil;
    self.timestamp          = nil;
    self.expiration         = nil;
    self.annotations        = [[NSDictionary alloc] init];
    self.trustedAnnotations = [[NSDictionary alloc] init];
    self.clickCount         = nil;

    [self.images             release]; // Don't over-retain our instance variables.
    [self.annotations        release];
    [self.trustedAnnotations release];
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self.postKey            release];
  [self.location           release];
  [self.category           release];
  [self.source             release];
  [self.heading            release];
  [self.body               release];
  [self.latitude           release];
  [self.longitude          release];
  [self.language           release];
  [self.price              release];
  [self.currency           release];
  [self.images             release];
  [self.externalID         release];
  [self.externalURL        release];
  [self.accountName        release];
  [self.accountID          release];
  [self.timestamp          release];
  [self.expiration         release];
  [self.annotations        release];
  [self.trustedAnnotations release];
  [self.clickCount         release];

  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
