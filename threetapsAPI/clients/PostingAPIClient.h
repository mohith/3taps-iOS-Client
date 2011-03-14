//  PostingAPIClient.h
//  threetapsAPI
//
//  Created by Erik Westra on 13/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

#import "APIClient.h"
#import "PostingAPIClientDelegate.h"

// ################################################################################################
//
// PostingAPIClient
//
//     This 3taps API client provides asynchronous access to the 3taps Posting API.

@interface PostingAPIClient : APIClient {

  @private
  <PostingAPIClientDelegate> _delegate;
}

@property (nonatomic, retain) <PostingAPIClientDelegate> _delegate;

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
//     Set our |PostingAPIClientDelegate| object.
//
//     Our delegate object will respond when Posting API calls have been completed.

- (void) setDelegate:(<PostingAPIClientDelegate>)delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// get:
//
//     Retrieve a posting with the given postKey.
//
//     We retrieve the given posting from the 3taps database.  Upon completion, one of the
//     following delegate methods will be called as appropriate:
//
//         getFinished:
//         getFailedWithError:

- (void) get:(NSString*)postKey;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// create:
//
//     Add a posting to the 3taps database.
//
//     'posting' should be a |Posting| object representing the posting to create.  Note that the
//     posting should not include a 'postKey' value, as this will be calculated by the 3taps system
//     itself.
//
//     We attempt to insert the new posting into the 3taps system.  Upon completion, one of the
//     following delegate methods will be called as appropriate:
//
//         createFinished:
//         createFailedWithError:

- (void) create:(Posting*)posting;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// createMany:
//
//     Add multiple postings to the 3taps database.
//
//     'postings' should be an |NSArray| of |Posting| objects representing the postings to create.
//     Note that the postings should not include a 'postKey' value, as these will be calculated by
//     the 3taps system itself.
//
//     We attempt to insert the new postings into the 3taps system.  Upon completion, one of the
//     following delegate methods will be called as appropriate:
//
//         createManyFinished:
//         createManyFailedWithError:

- (void) createMany:(NSArray*)postings;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// update:
//
//     Update the contents of a posting in the 3taps system.
//
//     'posting' should be a |Posting| object, which includes the posting key of the posting to
//     update.  Any other values set in the |Posting| object will be used to override the existing
//     value in the 3taps database.
//
//     We attempt to update the given posting in the 3taps system.  Upon completion, one of the
//     following delegate methods will be called as appropriate:
//
//         updateFinished:
//         updateFailedWithError:

- (void) update:(Posting*)posting;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// updateMany:
//
//     Update the contents of multiple postings in the 3taps system.
//
//     'postings' should be an |NSArray| of |Posting| objects, where each |Posting| object includes
//     the posting key of the posting to update.  Any other values set in the |Posting| objects
//     will be used to override the existing values in the 3taps database.
//
//     We attempt to update the given postings in the 3taps system.  Upon completion, one of the
//     following delegate methods will be called as appropriate:
//
//         updateManyFinished:
//         updateManyFailedWithError:

- (void) updateMany:(NSArray*)postings;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// delete:
//
//     Delete the posting with the given posting key from the 3taps system.
//
//     We ask the 3taps server to delete the given posting.  Upon completion, one of the following
//     delegate methods will be called as appropriate:
//
//         deleteFinished:
//         deleteFailedWithError:

- (void) delete:(NSString*)postKey;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// deleteMany:
//
//     Delete multiple postings from the 3taps system.
//
//     'postKeys' should be an |NSArray| of posting keys to delete.
//
//     We ask the 3taps server to delete the given postings.  Upon completion, one of the following
//     delegate methods will be called as appropriate:
//
//         deleteManyFinished:
//         deleteManyFailedWithError:

- (void) deleteMany:(NSArray*)postKeys;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################
//
// CreatePostingResult
//
//     This object encapsulates the result of an attempt to add a new posting to the 3taps system.
//
//     When creating a new posting, the attempt can either fail or succeed.  If the creation
//     attempt succeeds, a new posting key will be allocated for the posting.  If the creation
//     attempt fails, an error code and error message will be returned, explaining why the posting
//     was not accepted.

@interface CreatePostingResult : NSObject {
  @public
  BOOL      accepted;     // Was the posting accepted?
  NSString* postKey;      // The calculated posting key for the accepted posting.
  int       errorCode;    // The error code explaining why the posting was rejected.
  NSString* errorMessage; // A string describing why the posting was rejected.
}

@property (nonatomic, assign) BOOL      accepted;
@property (nonatomic, retain) NSString* postKey;
@property (nonatomic, assign) int       errorCode;
@property (nonatomic, retain) NSString* errorMessage;

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
