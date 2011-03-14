//  StatusAPIClient.h
//  threetapsAPI
//
//  Created by Erik Westra on 13/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

#import "APIClient.h"
#import "StatusAPIClientDelegate.h"

// ################################################################################################
//
// StatusAPIClient
//
//     This 3taps API client provides asynchronous access to the 3taps Status API.

@interface StatusAPIClient : APIClient {

  @private
  <StatusAPIClientDelegate> _delegate;
}

@property (nonatomic, retain) <StatusAPIClientDelegate> _delegate;

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

- (void) dealloc;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// setDelegate:
//
//     Set our |StatusAPIClientDelegate| object.
//
//     Our delegate object will respond when Status API calls have been completed.

- (void) setDelegate:(<StatusAPIClientDelegate>)delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// updateStatus:
//
//     Send an array of status updates to the 3taps server.
//
//     'updates' should be an |NSArray| of |StatusUpdate| objects, one for each posting which
//     should have its status updated.  Upon completion, one of the following delegate methods will
//     be called, as appropriate:
//
//         statusUpdated
//         statusUpdateFailedWithError:

- (void) updateStatus:(NSArray*)updates;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getStatusHistory:
//
//     Retrieve the status history for one or more postings.
//
//     'postings' should be an |NSArray| of |Posting| objects, defining the postings to retrieve
//     the status history for.  Each |Posting| object should have just the following two fields
//     filled in:
//
//         externalID
//         source
//
//     Upon completion, one of the following delegate methods will be called, as appropriate:
//
//         gotStatusHistory:
//         getStatusHistoryFailedWithError:

- (void) getStatusHistory:(NSArray*)postings;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getSystemStatus
//
//     Return the current status of the 3taps system itself.
//
//     Upon completion, one of the following delegate methods will be called, as appropriate:
//
//         gotSystemStatusCode:message:
//         getSystemStatusFailedWithError:

- (void) getSystemStatus;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################
//
// Valid |StatusUpdate| status values:

typedef enum {
  StatusUpdateStatusNone,
  StatusUpdateStatusFound,
  StatusUpdateStatusGot,
  StatusUpdateStatusProcessed,
  StatusUpdateStatusSent,
  StatusUpdateStatusReceived,
  StatusUpdateStatusIndexed
} StatusUpdateStatus;

// ################################################################################################
//
// StatusUpdate
//
//     This class encapsulates a status update to be sent to the 3taps Status API.
//
//     An instance of |StatusUpdate| has the following instance variables:
//
//         'status'
//
//             The post's current status.  Possible values are defined by the |StatusUpdateStatus|
//             type definition, above.
//
//         'externalID'
//
//             The external ID for this posting in the source system.
//
//         'source'
//
//             The 5-character source code for this posting.
//
//         'timestamp'
//
//             An |NSDate| object representing the date and time at which this status update
//             occurred, in UTC.  If this is |nil|, the timestamp will default to "now".
//
//         'attributes'
//
//             An optional |NSDictionary| mapping attribute names to values for additional
//             information to remember for this status update.
//
//     These instance variables can be set and retrieved directly.

@interface StatusUpdate : NSObject {
  @public
  StatusUpdateStatus status;
  NSString*          externalID;
  NSString*          source;
  NSDate*            timestamp;
  NSDictionary*      attributes;
}

@property (nonatomic, assign) StatusUpdateStatus status;
@property (nonatomic, retain) NSString*          externalID;
@property (nonatomic, retain) NSString*          source;
@property (nonatomic, retain) NSDate*            timestamp;
@property (nonatomic, retain) NSDictionary*      attributes;

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

- (void) dealloc;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
