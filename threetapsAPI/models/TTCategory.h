//  Category.h
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

// ################################################################################################
//
// Category
//
//     The |Category| class represents a category within the 3taps client APIs.
//
//     A |Category| object has the following attributes:
//
//         code
//
//             A brief string uniquely identifying this category.
//
//         group
//
//             A string identifying the group this category belongs to.
//
//         name
//
//             A string containing the name of this category.
//
//         annotations
//
//             A list of |Annotation| objects for the annotations associated with this category.
//
//     You can retrieve and change these attributes directly as required.

@interface TTCategory : NSObject {
  @public
  NSString* code;
  NSString* group;
  NSString* name;
  NSArray*  annotations;
}

@property (nonatomic, retain) NSString* code;
@property (nonatomic, retain) NSString* group;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSArray*  annotations;

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
