//  AppDelegate.h
//  threetappAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011 3taps, inc.  All rights reserved.

#import <UIKit/UIKit.h>

// ###########################################################################
//
// AppDelegate
//
//     Our main application delegate object.
//
//     Note that our app only has a very basic interface, with a single button that runs through
//     the unit tests when the user taps on it.

@interface AppDelegate : NSObject <UIApplicationDelegate> {
  @private
  UIWindow* _window; // Our application's window.
  UIView*   _view;   // Our application's view.
  UIButton* _button; // Our application's button.
}

@property (nonatomic, retain) UIWindow* _window;
@property (nonatomic, retain) UIView*   _view;
@property (nonatomic, retain) UIButton* _button;

@end

