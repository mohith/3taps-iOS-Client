//  APIClient.m
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "APIClient.h"

#import "APIConstants.h"

// ################################################################################################

@implementation APIClient

@synthesize _apiBaseURL;
@synthesize _apiPort;
@synthesize _logRequests;
@synthesize _activeConnections;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self._apiBaseURL        = DEFAULT_API_URL;
    self._apiPort           = DEFAULT_API_PORT;
    self._logRequests       = FALSE;
    self._activeConnections = [[NSMutableArray alloc] init];

    [self._activeConnections release]; // Don't over-retain our instance variables.
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  // Cancel any still-active API connections.

  for (APIConnection* connection in self._activeConnections) {
    if ([connection getStatus] == APIConnectionStatusInProgress) {
      [connection cancel];
    }
  }

  [self._apiBaseURL        release];
  [self._activeConnections release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) setBaseURL:(NSString*)baseURL port:(int)port {

  self._apiBaseURL = baseURL;
  self._apiPort    = port;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) enableLogging {

  self._logRequests = TRUE;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) disableLogging {

  self._logRequests = FALSE;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString*) getURL:(NSString*)endpoint {

  return [NSString stringWithFormat:@"%@:%d/%@", self._apiBaseURL, self._apiPort, endpoint];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) connectionStarted:(APIConnection*)connection {

  if (self._logRequests) {
    [connection logConnectionDetails];
  }

  [self._activeConnections addObject:connection];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) connectionStopped:(APIConnection*)connection {

  [self._activeConnections removeObject:connection];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
