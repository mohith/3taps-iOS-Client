//  APIConnection.h
//  threetapsAPI
//
//  Created by Erik Westra on 12/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

#import "APIError.h"

// ################################################################################################

// The following constants define the various states of the API connection:

typedef enum {
    APIConnectionStatusNotStarted,
    APIConnectionStatusInProgress,
    APIConnectionStatusFinished,
    APIConnectionStatusFailed,
    APIConnectionStatusCancelled
} APIConnectionStatus;

// ################################################################################################

// The following constants define the various types of HTTP requests we can make:

typedef enum {
    APIConnectionRequestTypeGET,
    APIConnectionRequestTypePOST
} APIConnectionRequestType;

// ################################################################################################
//
// APIConnection
//
//      This class provides a generic mechanism for communicating with the 3taps APIs.  The
//      response data is downloaded asynchronously, and the download can be cancelled at any time.
//
//      Note that we automatically display the application's network activity indicator while any
//      instance of |APIConnection| is active.

@interface APIConnection : NSObject {
  @private
  APIConnectionStatus      _status;         // Our current download status.
  NSString*                _reqURL;         // The URL to send the request to.
  APIConnectionRequestType _reqType;        // Our request type.  Defaults to "GET".
  NSString*                _reqContentType; // Our specified content-type, if any.
  NSData*                  _reqData;        // Data to send in the body of our request, if any.
  NSObject*                _target;         // Target object to send our message to.
  SEL                      _selector;       // Which method to call in the target object.
  NSString*                _mimeType;       // The MIME type returned by the server.
  NSMutableData*           _responseData;   // Holds the data as we download it from the server.
  APIError*                _curError;       // The returned error object, if an error occurred.
  NSURLConnection*         _curConnection;  // Our URL connection object.
  NSString*                _authID;         // The authID to use, set in plist.
}

@property (nonatomic, assign) APIConnectionStatus      _status;
@property (nonatomic, retain) NSString*                _reqURL;
@property (nonatomic, assign) APIConnectionRequestType _reqType;
@property (nonatomic, retain) NSString*                _reqContentType;
@property (nonatomic, retain) NSData*                  _reqData;
@property (nonatomic, retain) NSObject*                _target;
@property (nonatomic, assign) SEL                      _selector;
@property (nonatomic, retain) NSString*                _mimeType;
@property (nonatomic, retain) NSMutableData*           _responseData;
@property (nonatomic, retain) APIError*                _curError;
@property (nonatomic, retain) NSURLConnection*         _curConnection;
@property (nonatomic, retain) NSString*                _authID;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// init
//
//     Initialise a new |APIConnection| object.

- (id) init;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// dealloc
//
//     Release the memory used by this |APIConnection| object.

- (void) dealloc;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// setURL:
//
//     Set the URL to use for downloading data.

- (void) setURL:(NSString*)downloadURL;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getURL
//
//     Return the URL used for downloading data.

- (NSString*) getURL;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// setRequestType:
//
//     Set the HTTP request type to use when sending this request to the server.
//
//     If this method is not called, the request type will default to
//     |APIConnectionRequestTypeGET|.

- (void) setRequestType:(APIConnectionRequestType)requestType;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// setContentType:
//
//     Set the HTTP content type to use when sending this request to the server.
//
//     If this method is not called, no content-type will be specified when the request is sent.

- (void) setContentType:(NSString*)contentType;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// setRequestData:
//
//     Set additional data to sent in the body of this request.
//
//     The given data will be sent as the body of the HTTP request.

- (void) setRequestData:(NSData*)requestData;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// setFormValues:
//
//     Prepare to send a "form" of key-value pairs when sending this request to the server.
//
//     We take a dictionary of key-value pairs, combine them into a URL-encoded string and use
//     that string as the body of the request.  The HTTP request type will be set to "POST", and
//     the content-type will be set to "application/x-www-form-urlencoded".
//
//     Note that you do not need to call |setRequestType|, |setContentType| or |setRequestData|
//     after calling |setFormValues|, as these calls are made already.

- (void) setFormValues:(NSDictionary*)formValues;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// setTarget:withSelector:
//
//     Set the target object which will respond to the download completing or failing.  The given
//     method of the given object will be called with a single parameter (the |APIConnection|
//     object) when the data has been received or if an error occurs.

- (void) setTarget:(NSObject*)target withSelector:(SEL)selector;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// logConnectionDetails
//
//     Write a summary of the APIConnection to the system console.
//
//     A summary of the connection type, URL, and request data will be written as a one-line
//     summary to the console log.

- (void) logConnectionDetails;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// start
//
//     Start downloading the requested data from the specified URL.

- (void) start;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// cancel
//
//     Cancel a request in progress.

- (void) cancel;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getStatus
//
//     Return the current status of this |APIConnection|.  See above for the various status codes
//     which can be returned.

- (APIConnectionStatus) getStatus;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getMimeType
//
//     Return the MIME type associated with the data which has been downloaded.  If the
//     |APIConnection| did not finish downloading, returns nil.

- (NSString*) getMimeType;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getData
//
//     Return the data downloaded by this |APIConnection|.  If the APIConnection has not finished
//     downloading, returns nil.

- (NSData*) getData;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getError
//
//     Return the error associated with a failed download attempt.  If the APIConnection did not
//     fail, returns nil.

- (APIError*) getError;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
