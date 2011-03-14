//  PostingAPIClientTester.h
//  threetapsAPI
//
//  Created by Erik Westra on 12/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

#import "PostingAPIClient.h"
#import "PostingAPIClientDelegate.h"

// ################################################################################################
//
// PostingAPIClientTester
//
//     This class implements a series of unit tests for the |PostingAPIClient| class.
//
//     Note that, because the |PostingAPIClient| runs asyncronously, it is tricky to implement
//     synchronous unit tests for this class.  Instead, we define a method which initiates the
//     appropriate call, and logs the success or failure to the system console.

@interface PostingAPIClientTester : NSObject <PostingAPIClientDelegate> {
  @private
  PostingAPIClient* _client;   // The |PostingAPIClient| we are testing.
  NSObject*         _target;   // Target object to call once our tests have finished.
  SEL               _selector; // selector to call once our tests have finished.
  NSArray*          _postKeys; // Posting keys of the post(s) we have created.
}

@property (nonatomic, retain) PostingAPIClient* _client;
@property (nonatomic, retain) NSObject*         _target;
@property (nonatomic, assign) SEL               _selector;
@property (nonatomic, retain) NSArray*          _postKeys;

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
// runWithCompletionTarget:selector:
//
//     Run the unit tests on our |PostingAPIClient|.
//
//     We start the first API test, which runs asyncronously.  Once the first test has finished,
//     the second test is started, and so on until all the Posting API tests have been completed.
//     Once the final test has been finished, the given method of the given object will be called
//     to notify the testing system that the Posting API tests have finished.

- (void) runWithCompletionTarget:(NSObject*)target selector:(SEL)selector;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
