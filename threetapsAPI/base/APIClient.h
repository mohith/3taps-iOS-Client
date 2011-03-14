//  APIClient.h
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

#import "APIConnection.h"

// ################################################################################################
//
// APIClient
//
//     The base class for the various 3taps API clients.
//
//     The |APIClient| class provides the underlying functionality needed to asynchronously access
//     the 3taps API and process a response.

@interface APIClient : NSObject {
  @private
  NSString*       _apiBaseURL;        // Base URL used to access the 3taps APIs.
  int             _apiPort;           // HTTP port used to access the 3taps APIs.
  BOOL            _logRequests;       // Log API requests to the console?
  NSMutableArray* _activeConnections; // Array of active |APIConnection| objects.
}

@property (nonatomic, retain) NSString*       _apiBaseURL;
@property (nonatomic, assign) int             _apiPort;
@property (nonatomic, assign) BOOL            _logRequests;
@property (nonatomic, retain) NSMutableArray* _activeConnections;

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                  P U B L I C   M E T H O D S                                  //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////
//
// init
//
//     Our designated initializer.

- (id) init;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// dealloc
//
//     Release the memory used by our instance variables.
//
//     Note that if we have any active API connections, they are cancelled.

- (void) dealloc;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// setBaseURL:port:
//
//     Set the base URL and HTTP port used to access the 3taps APIs.
//
//     If this method is not called, the base URL and HTTP port will be set to the default values
//     as defined in the APIConstants.h module.

- (void) setBaseURL:(NSString*)baseURL port:(int)port;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// enableLogging
//
//     Turn on logging of API requests.
//
//     After calling this method, all active API requests will be written to the console.  This can
//     be useful for debugging.

- (void) enableLogging;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// disableLogging
//
//     Turn off logging of API requests.
//
//     After calling this method, active API requests will no longer be written to the console.

- (void) disableLogging;

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//    M E T H O D S   T O   B E   C A L L E D   B Y   A P I C L I E N T   S U B C L A S S E S    //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getURL:
//
//     Build and return the URL to use to access the given API endpoint.
//
//     We construct a URL out of the APIClient's base URL and HTTP port, combined with the given
//     relative URL.

- (NSString*) getURL:(NSString*)endpoint;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// connectionStarted:
//
//     Remember that an |APIConnection| object is currently downloading data for this API Client.
//
//     This should be called by the |APIClient| subclass whenever an |APIConnection| object is used
//     to asynchronously download data from the 3taps server.  We keep track of all active
//     |APIConnection| objects, and automatically cancel then when the |APIClient| object is
//     deallocated.  We also call the connection's 'logConnectionDetails' method if logging is
//     currently turned on.

- (void) connectionStarted:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// connectionStopped:
//
//     Remember that an |APIConnection| object has stopped downloading data for this API Client.
//
//     This should be called by the |APIClient| subclass whenever an |APIConnection| object that
//     was previously passed to 'connectionStarted:' is no longer downloading data from the 3taps
//     server.  We keep track of all active |APIConnection| objects, and automatically cancel then
//     when the |APIClient| object is deallocated.

- (void) connectionStopped:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
