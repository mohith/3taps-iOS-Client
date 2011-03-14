//  StatusAPIClientDelegate.h
//  threetapsAPI
//
//  Created by Erik Westra on 13/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <UIKit/UIKit.h>

#import "APIError.h"

// ################################################################################################
//
// StatusAPIClientDelegate
//
//     This formal protocol defines the methods which a |StatusAPIClient| delegate object must
//     implement in order to respond to a completed Status API call.
//
//     Note that while all the methods of this protocol are optional, an |NSException| will be
//     raised if an API call is made and the required delegate method has not been implemented.

@protocol StatusAPIClientDelegate <NSObject>

@optional

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// statusUpdated
//
//     Respond to an |updateStatus:| API call successfully finishing.

- (void) statusUpdated;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// statusUpdateFailedWithError:
//
//     Respond to an error occurring while performing the |updateStatus:| API call.

- (void) statusUpdateFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// gotStatusHistory:
//
//     Respond to a |getStatusHistory| API call successfully finishing.
//
//     'history' will be an |NSArray| of postings for which we were asked to retrieve the status
//     history.  Each item in this array will be an |NSDictionary| with the following entries:
//
//         'externalID'
//
//             The external ID of the posting, copied from the |Posting| object supplied to the
//             |getStatusHistory| API call.
//
//         'source'
//
//             The source of the posting, copied from the |Posting| object supplied to the
//             |getStatusHistory| API call.
//
//         'exists'
//
//             An |NSNumber| object containing a boolean value.  This will be set to TRUE if and
//             only if the 3taps Status API has history information for the given posting.
//
//         'statuses'
//
//             An |NSDictionary| mapping StatusUpdateStatus values (encapsulated in an |NSNumber|
//             object) to an |NSArray| of updates received for this posting and status value.  Each
//             item in the array of updates will itself be an |NSDictionary| with the following
//             entries:
//
//                 'timestamp'
//
//                     An |NSDate| object holding the date and time at which this update occurred,
//                     in UTC.
//
//                 'errors'
//
//                     An |NSArray| of errors which have occurred while updating this posting's
//                     status.  Each item in this list will be an |APIError| object.
//
//                 'attributes'
//
//                     An |NSDictionary| mapping attribute names to values, reflecting the
//                     attribute values that were passed to the |updateStatus:| API call.

- (void) gotStatusHistory:(NSArray*)history;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getStatusHistoryFailedWithError:
//
//     Respond to an error occurring while performing the |getStatusHistory:| API call.

- (void) getStatusHistoryFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// gotSystemStatusCode:message:
//
//     Respond to a |getSystemStatus| API call successfully finishing.
//
//     'code' will be a 3taps system status code value reflecting the current status of the 3taps
//     system, and 'message' will be a string describing that status in a human-readable form.

- (void) gotSystemStatusCode:(int)code message:(NSString*)message;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getSystemStatusFailedWithError:
//
//     Respond to an error occurring while performing the |getSystemStatus| API call.

- (void) getSystemStatusFailedWithError:(APIError*)error;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
