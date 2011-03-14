//  StatusAPIClientTester.h
//  threetapsAPI
//
//  Created by Erik Westra on 12/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

#import "StatusAPIClient.h"
#import "StatusAPIClientDelegate.h"

// ################################################################################################
//
// StatusAPIClientTester
//
//     This class implements a series of unit tests for the |StatusAPIClient| class.
//
//     Note that, because the |StatusAPIClient| runs asyncronously, it is tricky to implement
//     synchronous unit tests for this class.  Instead, we define a method which initiates the
//     appropriate call, and logs the success or failure to the system console.

@interface StatusAPIClientTester : NSObject <StatusAPIClientDelegate> {
  @private
  StatusAPIClient* _client;     // The |StatusAPIClient| we are testing.
  NSObject*        _target;     // Target object to call once our tests have finished.
  SEL              _selector;   // selector to call once our tests have finished.
  NSString*        _externalID; // External ID value used to test update/get status calls.
}

@property (nonatomic, retain) StatusAPIClient* _client;
@property (nonatomic, retain) NSObject*        _target;
@property (nonatomic, assign) SEL              _selector;
@property (nonatomic, retain) NSString*        _externalID;

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
//     Run the unit tests on our |StatusAPIClient|.
//
//     We start the first API test, which runs asyncronously.  Once the first test has finished,
//     the second test is started, and so on until all the Status API tests have been completed.
//     Once the final test has been finished, the given method of the given object will be called
//     to notify the testing system that the Status API tests have finished.

- (void) runWithCompletionTarget:(NSObject*)target selector:(SEL)selector;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
