//  APIConnection.m
//  threetapsAPI
//
//  Created by Erik Westra on 12/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "APIConnection.h"

// ################################################################################################
//
// The following private global is used to keep track of the currently-active API connections.  It
// is used by the |connectionIsActive:| and |connectionIsInactive:| class methods to keep track of
// the total number of active API connections and automatically start/top the application's network
// activity indicator as required.

static NSCountedSet* _activeConnections = nil;

// ################################################################################################
//
// Private method definitions:

@interface APIConnection (private)

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// connectionIsActive:
//
//     Remember that the given |APIConnection| object is currently active.
//
//     We use this to keep track of the currently-active |APIConnection| objects, and automatically
//     start/stop the application's network activity indicator as required.

+ (void) connectionIsActive:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// connectionIsInactive:
//
//     Remember that the given |APIConnection| object is currently inactive.
//
//     We use this to keep track of the currently-active |APIConnection| objects, and automatically
//     start/stop the application's network activity indicator as required.

+ (void) connectionIsInactive:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// urlEncodeString
//
//     URL-encode the given string.
//
//     Return the given string with all "non-safe" characters converted into HTML safe equivalents
//     using percent escape codes.

- (NSString*) urlEncodeString:(NSString*)string;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################

@implementation APIConnection

@synthesize _status;
@synthesize _reqURL;
@synthesize _reqType;
@synthesize _reqContentType;
@synthesize _reqData;
@synthesize _target;
@synthesize _selector;
@synthesize _mimeType;
@synthesize _responseData;
@synthesize _curError;
@synthesize _curConnection;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  self._status         = APIConnectionStatusNotStarted;
  self._reqURL         = nil;
  self._reqType        = APIConnectionRequestTypeGET;
  self._reqContentType = nil;
  self._reqData        = nil;
  self._target         = nil;
  self._selector       = nil;
  self._mimeType       = nil;
  self._responseData   = [[NSMutableData alloc] init];
  self._curError       = nil;
  self._curConnection  = nil;

  [self._responseData release]; // Don't over-retain our instance vars.

  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self._reqURL         release];
  [self._reqContentType release];
  [self._reqData        release];
  [self._target         release];
  [self._mimeType       release];
  [self._responseData   release];
  [self._curError       release];
  [self._curConnection  release];

  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) setURL:(NSString*)downloadURL {

  self._reqURL = downloadURL;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString*) getURL {

  return self._reqURL;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) setRequestType:(APIConnectionRequestType)requestType {

  self._reqType = requestType;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) setContentType:(NSString*)contentType {

  self._reqContentType = contentType;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) setRequestData:(NSData*)requestData {

  self._reqData = requestData;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) setFormValues:(NSDictionary*)formValues {

  NSMutableArray* encodedValues = [[NSMutableArray alloc] init];

  for (NSString* key in formValues) {
    NSString* value = [formValues objectForKey:key];

    [encodedValues addObject:[NSString stringWithFormat:@"%@=%@",
                                                        [self urlEncodeString:key],
                                                        [self urlEncodeString:value]]];
  }

  NSString* encodedRequest = [encodedValues componentsJoinedByString:@"&"];
  [encodedValues release];

  //NSLog(@"sending request '%@' to %@", encodedRequest, self._reqURL);

  [self setRequestType:APIConnectionRequestTypePOST];
  [self setContentType:@"application/x-www-form-urlencoded"];
  [self setRequestData:[encodedRequest dataUsingEncoding:NSUTF8StringEncoding]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) setTarget:(NSObject*)target withSelector:(SEL)selector {

  self._target   = target;
  self._selector = selector;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) logConnectionDetails {

  NSString* connectionType;
  if (self._reqType == APIConnectionRequestTypeGET) {
    connectionType = @"GET";
  } else if (self._reqType == APIConnectionRequestTypePOST) {
    connectionType = @"POST";
  } else {
    connectionType = @"???";
  }

  NSString* requestData = [[NSString alloc] initWithData:self._reqData
                                                encoding:NSUTF8StringEncoding];
  if ([requestData length] > 50) {
    requestData = [NSString stringWithFormat:@"%@...", [requestData substringToIndex:50]];
  }

  NSLog(@"%@ %@ %@", connectionType, self._reqURL, requestData);
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) start {

  NSAssert(self._reqURL != nil, @"APIConnection: URL not specified!");
  NSAssert(self._target != nil, @"APIConnection: Target not specified!");

  NSURL* url = [NSURL URLWithString:self._reqURL];
  NSMutableURLRequest* request = [NSMutableURLRequest
                                        requestWithURL:url
                                        cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        timeoutInterval:10.0];

  if (self._reqType == APIConnectionRequestTypeGET) {
    [request setHTTPMethod:@"GET"];
  } else {
    [request setHTTPMethod:@"POST"];
  }

  if (self._reqContentType != nil) {
    [request setValue:self._reqContentType forHTTPHeaderField:@"content-type"];
  }

  if (self._reqData != nil) {
    [request setHTTPBody:self._reqData];
  }

  self._curConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
  self._status        = APIConnectionStatusInProgress;

  [APIConnection connectionIsActive:self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) cancel {

  NSAssert(self._status == APIConnectionStatusInProgress,
           @"NSDownloader: cancelling connection not in progress!");

  [self._curConnection cancel];
  self._status = APIConnectionStatusCancelled;

  [APIConnection connectionIsInactive:self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (APIConnectionStatus) getStatus {

  return self._status;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString*) getMimeType {

  if (self._status != APIConnectionStatusFinished) {
    return nil;
  }
  return self._mimeType;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (NSData*) getData {

  if (self._status != APIConnectionStatusFinished) {
    return nil;
  }
  return self._responseData;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (APIError*) getError {

  if (self._status != APIConnectionStatusFailed) {
    return nil;
  }
  return self._curError;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//             N S U R L C O N N E C T I O N   D E L E G A T E   M E T H O D S                   //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////
//
// connection:didReceiveResponse:
//
//     Called when the server sends back a response.

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {

  self._mimeType = [response MIMEType];
  [self._responseData setLength:0];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// connection:didReceiveData:
//
//     Called when some data has been received from the remote server.

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {

  [_responseData appendData:data];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// connection:didFailWithError:
//
//     Called when an error occurs.

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {

  self._curError = [[APIError alloc] initWithCode:error.code
                                          message:[error localizedFailureReason]];
  self._status   = APIConnectionStatusFailed;
  [self._target performSelector:self._selector withObject:self]; // Tell target that we failed.
  [APIConnection connectionIsInactive:self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// connectionDidFinishLoading:
//
//     Called when all the data has been downloaded.

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {

  [connection release];
  self._status = APIConnectionStatusFinished;
  [self._target performSelector:self._selector withObject:self]; // Tell target that we've finished.
  [APIConnection connectionIsInactive:self];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                 P R I V A T E   M E T H O D S                                 //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

+ (void) connectionIsActive:(APIConnection*)connection {

  if (_activeConnections == nil) {
    _activeConnections = [[NSCountedSet alloc] init];
  }

  [_activeConnections addObject:connection];

  if ([_activeConnections count] == 1) {
    // The first API connection is now active -> show the network activity indicator.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

+ (void) connectionIsInactive:(APIConnection*)connection {

  if (_activeConnections == nil) {
    _activeConnections = [[NSCountedSet alloc] init];
  }

  [_activeConnections removeObject:connection];

  if ([_activeConnections count] == 0) {
    // The last API connection is now inactive -> hide the network activity indicator.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString*) urlEncodeString:(NSString*)string {

  NSString* encodedString;
  encodedString = (NSString*)CFURLCreateStringByAddingPercentEscapes(nil, (CFStringRef)string, nil,
                                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                       kCFStringEncodingUTF8);
  return [encodedString autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

