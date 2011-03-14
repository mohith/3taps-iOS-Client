//  GeocoderAPIClient.m
//  threetapsAPI
//
//  Created by Erik Westra on 13/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "JSON.h"

#import "GeocoderAPIClient.h"

#import "APIConnection.h"
#import "APIData.h"
#import "APIError.h"

// ################################################################################################
//
// Private method definitions:

@interface GeocoderAPIClient (private)

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// geocodeFinishedWith:
//
//    Respond to our 'geocode' API call finishing or failing.

- (void) geocodeFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################

@implementation GeocoderAPIClient

@synthesize _delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self._delegate = nil;
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self._delegate release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) setDelegate:(<GeocoderAPIClientDelegate>)delegate {

  self._delegate = delegate;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) geocode:(NSArray*)requests {

  NSMutableArray* data = [[NSMutableArray alloc] init];
  for (GeocodeRequest* request in requests) {
    NSMutableDictionary* posting = [[NSMutableDictionary alloc] init];
    if (request.latitude != nil) {
      [posting setObject:request.latitude forKey:@"latitude"];
    }
    if (request.longitude != nil) {
      [posting setObject:request.longitude forKey:@"longitude"];
    }
    if (request.country != nil) {
      [posting setObject:request.country forKey:@"country"];
    }
    if (request.state != nil) {
      [posting setObject:request.state forKey:@"state"];
    }
    if (request.city != nil) {
      [posting setObject:request.city forKey:@"city"];
    }
    if (request.locality != nil) {
      [posting setObject:request.locality forKey:@"locality"];
    }
    if (request.street != nil) {
      [posting setObject:request.street forKey:@"street"];
    }
    if (request.postal != nil) {
      [posting setObject:request.postal forKey:@"postal"];
    }
    if (request.text != nil) {
      [posting setObject:request.text forKey:@"text"];
    }

    [data addObject:posting];
  }

  SBJsonWriter* writer = [[SBJsonWriter alloc] init];
  NSString* jsonData = [writer stringWithObject:data];
  [writer release];
  [data release];

  NSDictionary* args = [NSDictionary dictionaryWithObject:jsonData forKey:@"data"];

  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"geocoder/geocode"]];
  [connection setFormValues:args];
  [connection setTarget:self
           withSelector:@selector(geocodeFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                 P R I V A T E   M E T H O D S                                 //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) geocodeFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate geocodeFailedWithError:results.error];
    [results release];
    return;
  }

  NSMutableArray* responses = [[NSMutableArray alloc] init];
  for (NSArray* data in (NSArray*)results.data) {
    GeocodeResponse* response = [[GeocodeResponse alloc] init];
    response.code      = [data objectAtIndex:0];
    response.latitude  = [data objectAtIndex:1];
    response.longitude = [data objectAtIndex:2];
    [responses addObject:response];
  }

  [self._delegate geocodeFinished:responses];

  [responses release];
  [results   release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################

@implementation GeocodeRequest

@synthesize latitude;
@synthesize longitude;
@synthesize country;
@synthesize state;
@synthesize city;
@synthesize locality;
@synthesize street;
@synthesize postal;
@synthesize text;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self.latitude  = nil;
    self.longitude = nil;
    self.country   = nil;
    self.state     = nil;
    self.city      = nil;
    self.locality  = nil;
    self.street    = nil;
    self.postal    = nil;
    self.text      = nil;
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self.latitude  release];
  [self.longitude release];
  [self.country   release];
  [self.state     release];
  [self.city      release];
  [self.locality  release];
  [self.street    release];
  [self.postal    release];
  [self.text      release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################

@implementation GeocodeResponse

@synthesize code;
@synthesize latitude;
@synthesize longitude;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self.code      = nil;
    self.latitude  = nil;
    self.longitude = nil;
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self.code      release];
  [self.latitude  release];
  [self.longitude release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
