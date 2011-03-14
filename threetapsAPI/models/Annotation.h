//  Annotation.h
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import <Foundation/Foundation.h>

// ################################################################################################
//
// Supported annotation types:

typedef enum {
    AnnotationTypeUndefined,
    AnnotationTypeSelect,
    AnnotationTypeString,
    AnnotationTypeNumber
} AnnotationType;

// ################################################################################################
//
// Annotation
//
//     The |Annotation| object represents an annotation within the 3taps reference API.
//
//     An |Annotation| object has the following attributes:
//
//         name
//
//             The name of this annotation.
//
//         type
//
//             The type of annotation.
//
//         options
//
//             For annotations of type |AnnotationTypeSelect|, this will be an array of the
//             possible options supported by this annotation.  Each item in this array should be an
//             |AnnotationOption| object.
//
//     You can retrieve and change these attributes directly as required.

@interface Annotation : NSObject {
  @public
  NSString*      name;
  AnnotationType type;
  NSArray*       options;
}

@property (nonatomic, retain) NSString*      name;
@property (nonatomic, assign) AnnotationType type;
@property (nonatomic, retain) NSArray*       options;

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

// ################################################################################################
//
// AnnotationOption
//
//     The |AnnotationOption| object represents a single option for an |Annotation|.
//
//     The |AnnotationOption| object has the following attributes:
//
//         value
//
//             A string containing the value for this annotation option.
//
//         subAnnotation
//
//             If set, this is an |Annotation| object representing the sub-annotation for this
//             option.

@interface AnnotationOption : NSObject {
  @public
  NSString*   value;
  Annotation* subAnnotation;
}

@property (nonatomic, retain) NSString*   value;
@property (nonatomic, retain) Annotation* subAnnotation;

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
