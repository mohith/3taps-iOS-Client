//  AppDelegate.m
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011 3taps, inc.  All rights reserved.

#import "AppDelegate.h"

#import "AllTests.h"

// ################################################################################################
//
// Private method definitions:

@interface AppDelegate (private)

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// onButton
//
//     Respond to the user tapping on our button.
//
//     We start running the unit tests for the threetapsAPI library.  Note that the output of these
//     tests are written to the console window; there is no graphical interface for the unit tests.

- (void) onButton;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################

@implementation AppDelegate

@synthesize _window;
@synthesize _view;
@synthesize _button;

///////////////////////////////////////////////////////////////////////////////////////////////////

-              (BOOL) application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {    

  // Initialize the application.

  self._window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  self._view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self._view.backgroundColor = [UIColor grayColor];

  self._button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self._button.frame = CGRectMake(0, 0, self._view.bounds.size.width - 40, 30);
  self._button.center = self._view.center;
  [self._button setTitle:@"Run unit tests" forState:UIControlStateNormal];

  [self._button addTarget:self
                   action:@selector(onButton)
         forControlEvents:UIControlEventTouchDown];

  [self._view addSubview:self._button];
  [self._window addSubview:self._view];

  [self._window release]; // Don't over-retain our instance variables.
  [self._view   release];
  [self._button release];

  [self._window makeKeyAndVisible];

  return TRUE;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  // Release the memory used by our instance variables.

  [self._window release];
  [self._view   release];
  [self._button release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                 P R I V A T E   M E T H O D S                                 //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) onButton {

  AllTests* tester = [[AllTests alloc] init];
  [tester run];
  [tester release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
