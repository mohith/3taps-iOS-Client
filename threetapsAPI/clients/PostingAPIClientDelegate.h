//  PostingAPIClientDelegate.h
//  threetapsAPI
//
//  Created by Erik Westra on 13/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <UIKit/UIKit.h>

#import "APIError.h"
#import "Posting.h"

// ################################################################################################

@class CreatePostingResult;

// ################################################################################################
//
// PostingAPIClientDelegate
//
//     This formal protocol defines the methods which a |PostingAPIClient| delegate object must
//     implement in order to respond to a completed Posting API call.
//
//     Note that while all the methods of this protocol are optional, an |NSException| will be
//     raised if an API call is made and the required delegate method has not been implemented.

@protocol PostingAPIClientDelegate <NSObject>

@optional

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getFinished:
//
//     Respond to a |get:| API call successfully finishing.
//
//     'posting' is the |Posting| object with the details of the retrieved posting.

- (void) getFinished:(Posting*)posting;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getFailedWithError:
//
//     Respond to an error occurring while performing the |get:| API call.

- (void) getFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// createFinished:
//
//     Respond to a |create:| API call successfully finishing.
//
//     'result' is a |CreatePostingResult| object containing the results of the creation attempt.

- (void) createFinished:(CreatePostingResult*)result;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// createFailedWithError:
//
//     Respond to an error occurring while performing the |create:| API call.
//
//     Note that this will be called if there is a problem communicating with the 3taps server; if
//     the posting itself was rejected, the 'postCreated:' method will be called with an
//     appropriate posting result.

- (void) createFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// createManyFinished:
//
//     Respond to the |createMany:| API call successfully finishing.
//
//     'results' is an |NSArray| containing the results of the insertion attempts.  Each item in
//     the |results| list will be a |CreatePostingResult| object indicating whether the server
//     accepted or rejected this posting.

- (void) createManyFinished:(NSArray*)results;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// createManyFailedWithError:
//
//     Respond to an error occurring while performing the |createMany:| API call.

- (void) createManyFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// updateFinished:
//
//     Respond to an |update:| API call successfully finishing.
//
//     If 'success' is TRUE, the update request will have been accepted by the 3taps server.

- (void) updateFinished:(BOOL)success;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// updateFailedWithError:
//
//     Respond to an error occurring while performing the |update:| API call.

- (void) updateFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// updateManyFinished:
//
//     Respond to an |updateMany:| API call successfully finishing.
//
//     If 'success' is TRUE, the update request will have been accepted by the 3taps server.

- (void) updateManyFinished:(BOOL)success;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// updateManyFailedWithError:
//
//     Respond to an error occurring while performing the |updateMany:| API call.

- (void) updateManyFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// deleteFinished:
//
//     Respond to an |delete:| API call successfully finishing.
//
//     If 'success' is TRUE, the delete request will have been accepted by the 3taps server.

- (void) deleteFinished:(BOOL)success;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// deleteFailedWithError:
//
//     Respond to an error occurring while performing the |delete:| API call.

- (void) deleteFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// deleteManyFinished:
//
//     Respond to a |deleteMany:| API call successfully finishing.
//
//     If 'success' is TRUE, the delete request will have been accepted by the 3taps server.

- (void) deleteManyFinished:(BOOL)success;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// deleteManyFailedWithError:
//
//     Respond to an error occurring while performing the |deleteMany:| API call.

- (void) deleteManyFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
