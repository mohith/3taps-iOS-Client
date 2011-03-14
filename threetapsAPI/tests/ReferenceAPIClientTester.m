//  ReferenceAPIClientTester.m
//  threetapsAPI
//
//  Created by Erik Westra on 12/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "ReferenceAPIClientTester.h"

// ################################################################################################
//
// Private method definitions:

@interface ReferenceAPIClientTester (private)

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testGetCategories
//
//     Test the [ReferenceAPIClient getCategories] method.

- (void) testGetCategories;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testGetCategoriesWithAnnotations
//
//     Test the [ReferenceAPIClient getCategoriesWithAnnotations] method.

- (void) testGetCategoriesWithAnnotations;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testGetCategory
//
//     Test the [ReferenceAPIClient getCategory:] method.

- (void) testGetCategory;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testGetLocations
//
//     Test the [ReferenceAPIClient getLocations] method.

- (void) testGetLocations;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testGetSources
//
//     Test the [ReferenceAPIClient getSources] method.

- (void) testGetSources;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// testsFinished
//
//     Tell the rest of the testing framework that our unit tests have finished.
//
//     We call the selector and target object that was passed to our |runWithCompletionTarget|
//     method.

- (void) testsFinished;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################

@implementation ReferenceAPIClientTester

@synthesize _client;
@synthesize _target;
@synthesize _selector;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self._client = [[ReferenceAPIClient alloc] init];
    [self._client setDelegate:self];

    self._target   = nil;
    self._selector = nil;

    [self._client release]; // Don't over-retain our instance variables.
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self._client release];
  [self._target release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) runWithCompletionTarget:(NSObject*)target selector:(SEL)selector {

  self._target   = target;
  self._selector = selector;

  [self testGetCategories];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//              R E F E R E N C E A P I C L I E N T D E L E G A T E   M E T H O D S              //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) gotCategories:(NSArray*)categories {

  NSLog(@"[ReferenceAPIClient getCategories] successfully finished, downloaded %d categories",
        [categories count]);

  [self testGetCategoriesWithAnnotations];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getCategoriesFailedWithError:(APIError*)error {

  NSLog(@"[ReferenceAPIClient getCategories] failed: %@", [error description]);

  [self testGetCategoriesWithAnnotations];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) gotCategoriesWithAnnotations:(NSArray*)categories {
  
  NSLog(@"[ReferenceAPIClient getCategoriesWithAnnotations] successfully finished, "
        @"downloaded %d categories", [categories count]);

  [self testGetCategory];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getCategoriesWithAnnotationsFailedWithError:(APIError*)error {
  
  NSLog(@"[ReferenceAPIClient getCategories] failed: %@", [error description]);

  [self testGetCategory];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) gotCategory:(Category*)category {
  
  NSLog(@"[ReferenceAPIClient getCategory:] successfully finished");

  [self testGetLocations];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getCategoryFailedWithError:(APIError*)error {
  
  NSLog(@"[ReferenceAPIClient getCategory:] failed: %@", [error description]);

  [self testGetLocations];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) gotLocations:(NSArray*)locations {
  
  NSLog(@"[ReferenceAPIClient getLocations] successfully finished, downloaded %d locations",
        [locations count]);

  [self testGetSources];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getLocationsFailedWithError:(APIError*)error {
  
  NSLog(@"[ReferenceAPIClient getLocations] failed: %@", [error description]);

  [self testGetSources];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) gotSources:(NSArray*)sources {
  
  NSLog(@"[ReferenceAPIClient getSources] successfully finished, downloaded %d sources",
        [sources count]);

  [self testsFinished];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getSourcesFailedWithError:(APIError*)error {
  
  NSLog(@"[ReferenceAPIClient getSources] failed: %@", [error description]);

  [self testsFinished];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                 P R I V A T E   M E T H O D S                                 //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testGetCategories {

  NSLog(@"Testing [ReferenceAPIClient getCategories] API call...");
  [self._client getCategories];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testGetCategoriesWithAnnotations {

  NSLog(@"Testing [ReferenceAPIClient getCategoriesWithAnnotations] API call...");
  [self._client getCategoriesWithAnnotations];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testGetCategory {

  NSLog(@"Testing [ReferenceAPIClient getCategory:] API call...");
  [self._client getCategory:@"STVL"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testGetLocations {

  NSLog(@"Testing [ReferenceAPIClient getLocations] API call...");
  [self._client getLocations];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testGetSources {

  NSLog(@"Testing [ReferenceAPIClient getSources] API call...");
  [self._client getSources];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) testsFinished {

  [self._target performSelector:self._selector];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
