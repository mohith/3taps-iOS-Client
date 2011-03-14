//  Annotation.m
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "Annotation.h"

// ################################################################################################

@implementation Annotation

@synthesize name;
@synthesize type;
@synthesize options;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self.name    = nil;
    self.type    = AnnotationTypeUndefined;
    self.options = [[NSArray alloc] init];

    [self.options release]; // Don't over-retain our instance variables.
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self.name    release];
  [self.options release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################

@implementation AnnotationOption

@synthesize value;
@synthesize subAnnotation;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self.value         = nil;
    self.subAnnotation = nil;
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self.value         release];
  [self.subAnnotation release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
