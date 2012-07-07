//  ReferenceAPIClient.m
//  threetapsAPI
//
//  Created by Erik Westra on 11/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "ReferenceAPIClient.h"

#import "APIConnection.h"
#import "APIData.h"
#import "APIError.h"

#import "Annotation.h"
#import "Category.h"
#import "Location.h"
#import "Source.h"

// ################################################################################################
//
// Private method definitions:

@interface ReferenceAPIClient (private)

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getCategoriesFinishedWith:
//
//    Respond to our 'getCategories' API call finishing or failing.

- (void) getCategoriesFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getCategoriesWithAnnotationsFinishedWith:
//
//     Respond to our 'getCategoriesWithAnnotations' API call finishing or failing.

- (void) getCategoriesWithAnnotationsFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getCategoryFinishedWith:
//
//    Respond to our 'getCategory' API call finishing or failing.

- (void) getCategoryFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getLocationsFinishedWith:
//
//     respond to our 'getLocations' API call finishing or failing.

- (void) getLocationsFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getSourcesFinishedWith:
//
//     respond to our 'getSources' API call finishing or failing.

- (void) getSourcesFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// parseCategory:
//
//     Convert the JSON-format category data into a Category object.
//
//     'data' should be an |NSDictionary| with one or more of the following entries:
//
//         "group"
//         "category"
//         "code"
//         "annotations"
//
//     If it exists, the "annotations" entry should be a list of annotations for this category,
//     where each list item is itself a dictionary with one or more of the following entries:
//
//         "name"
//         "type"
//         "options"
//
//     'options' should be a list of annotation options, where each item in this list is a
//     dictionary with one or more of the following entries:
//
//         "value"
//         "subannotation"
//
//     Note that 'data' will be in the format received from the 3taps server after decoding the
//     JSON-format data.
//
//     We convert 'data' into a Category object, which we then return to the caller.

- (Category*) parseCategory:(NSDictionary*)data;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// parseAnnotation:
//
//     Convert the JSON-format annotation data into an Annotation object.
//
//     'data' should be an |NSDictionary| with one or more of the following entries:
//
//         "name"
//         "type"
//         "options"
//
//     'options' should be a list of annotation options, where each item in this list is a
//     dictionary with one or more of the following entries:
//
//         "value"
//         "subannotation"
//
//     Note that 'data' will be in the format received from the 3taps server after decoding the
//     JSON-format data.
//
//     We convert 'data' into an Annotation object, which we then return to the caller.

- (Annotation*) parseAnnotation:(NSDictionary*)data;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// parseLocation:
//
//     Convert the JSON-format annotation data into a Location object.
//
//     'data' should be an |NSDictionary| with one or more of the following entries:
//
//         "code"
//         "countryRank"
//         "country"
//         "cityRank"
//         "city"
//         "stateCode"
//         "stateName"
//         "hidden"
//         "latitude"
//         "longitude"
//
//     Note that this is the format received from the 3taps server after decoding the JSON-format
//     data.
//
//     We convert 'data' into a Location object, which we then return to the caller.

- (Location*) parseLocation:(NSDictionary*)data;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// parseSource:
//
//     Convert the JSON-format annotation data into a Source object.
//
//     'data' should be an |NSDictionary| with one or more of the following entries:
//
//         "code"
//         "name"
//         "logo_url"
//         "logo_sm_url"
//
//     Note that this is the format received from the 3taps server after decoding the JSON-format
//     data.
//
//     We convert 'data' into a Source object, which we then return to the caller.

- (Source*) parseSource:(NSDictionary*)data;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################

@implementation ReferenceAPIClient

@synthesize _delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self._delegate = nil;
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self._delegate release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) setDelegate:(<ReferenceAPIClientDelegate>)delegate {

  self._delegate = delegate;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getCategories {

  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"reference/category?annotations=false"]];
  [connection setTarget:self
           withSelector:@selector(getCategoriesFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getCategoriesWithAnnotations {
  
  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"reference/category?annotations=true"]];
  [connection setTarget:self
           withSelector:@selector(getCategoriesWithAnnotationsFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];
};

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getCategory:(NSString*)categoryCode {
  
  APIConnection* connection = [[APIConnection alloc] init];
  NSString* endpoint = [NSString stringWithFormat:@"reference/category/%@?annotations=true",
                                                  categoryCode];
  [connection setURL:[self getURL:endpoint]];
  [connection setTarget:self withSelector:@selector(getCategoryFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];
};

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getLocations {
  
  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"reference/location"]];
  [connection setTarget:self
           withSelector:@selector(getLocationsFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];
};

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getSources {
  
  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"reference/source"]];
  [connection setTarget:self
           withSelector:@selector(getSourcesFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];
};

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                 P R I V A T E   M E T H O D S                                 //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getCategoriesFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate getCategoriesFailedWithError:results.error];
    [results release];
    return;
  }

  NSMutableArray* categories = [[NSMutableArray alloc] init];
  for (NSDictionary* data in (NSArray*)results.data) {
    Category* category = [self parseCategory:data];
    [categories addObject:category];
  }

  [self._delegate gotCategories:categories];

  [categories release];
  [results    release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getCategoriesWithAnnotationsFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate getCategoriesWithAnnotationsFailedWithError:results.error];
    [results release];
    return;
  }

  NSMutableArray* categories = [[NSMutableArray alloc] init];
  for (NSDictionary* data in (NSArray*)results.data) {
    Category* category = [self parseCategory:data];
    [categories addObject:category];
  }

  [self._delegate gotCategoriesWithAnnotations:categories];

  [categories release];
  [results    release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getCategoryFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate getCategoryFailedWithError:results.error];
    [results release];
    return;
  }

  Category* category = nil;
  for (NSDictionary* data in (NSArray*)results.data) {
    category = [self parseCategory:data];
    break;
  }

  [self._delegate gotCategory:category];

  [results release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getLocationsFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate getLocationsFailedWithError:results.error];
    [results release];
    return;
  }

  NSMutableArray* locations = [[NSMutableArray alloc] init];
  for (NSDictionary* data in (NSArray*)results.data) {
    Location* location = [self parseLocation:data];
    [locations addObject:location];
  }

  [self._delegate gotLocations:locations];

  [locations release];
  [results   release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getSourcesFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate getSourcesFailedWithError:results.error];
    [results release];
    return;
  }

  NSMutableArray* sources = [[NSMutableArray alloc] init];
  for (NSDictionary* data in (NSArray*)results.data) {
    Source* source = [self parseSource:data];
    [sources addObject:source];
  }

  [self._delegate gotSources:sources];

  [sources release];
  [results release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (Category*) parseCategory:(NSDictionary*)data {

  Category* category = [[Category alloc] init];

  category.code  = [data objectForKey:@"code"];
  category.group = [data objectForKey:@"group"];
  category.name  = [data objectForKey:@"category"];

    if (!category.name) {
         NSLog(@"Parsing Category : %@",data);
    }
  if ([data objectForKey:@"annotations"] != nil) {
    NSMutableArray* annotations = [[NSMutableArray alloc] init];
    for (NSDictionary* annotationData in [data objectForKey:@"annotations"]) {
      Annotation* annotation = [self parseAnnotation:annotationData];
      [annotations addObject:annotation];
    }
    category.annotations = annotations;
  }

  return [category autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (Annotation*) parseAnnotation:(NSDictionary*)data {

  Annotation* annotation = [[Annotation alloc] init];

  annotation.name = [data objectForKey:@"name"];

  if ([[data objectForKey:@"type"] isEqualToString:@"select"]) {
    annotation.type = AnnotationTypeSelect;
  } else if ([[data objectForKey:@"type"] isEqualToString:@"string"]) {
    annotation.type = AnnotationTypeString;
  } else if ([[data objectForKey:@"type"] isEqualToString:@"number"]) {
    annotation.type = AnnotationTypeNumber;
  } else {
    annotation.type = AnnotationTypeUndefined;
  }

  if ([data objectForKey:@"options"] != nil) {
    NSMutableArray* options = [[NSMutableArray alloc] init];
    for (NSDictionary* optionData in [data objectForKey:@"options"]) {
      AnnotationOption* option = [[AnnotationOption alloc] init];
      option.value = [optionData objectForKey:@"value"];
      if ([optionData objectForKey:@"subannotation"] != nil) {
        option.subAnnotation = [self parseAnnotation:[optionData objectForKey:@"subannotation"]];
      }
      [options addObject:option];
    }
    annotation.options = options;
  }
  
  return annotation;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (Location*) parseLocation:(NSDictionary*)data {

  Location* location = [[Location alloc] init];

  location.code        = [data objectForKey:@"code"];
  location.countryRank = [data objectForKey:@"countryRank"];
  location.country     = [data objectForKey:@"country"];
  location.cityRank    = [data objectForKey:@"cityRank"];
  location.city        = [data objectForKey:@"city"];
  location.stateCode   = [data objectForKey:@"stateCode"];
  location.stateName   = [data objectForKey:@"stateName"];
  location.hidden      = [[data objectForKey:@"hidden"] boolValue];
  location.latitude    = [data objectForKey:@"latitude"];
  location.longitude   = [data objectForKey:@"longitude"];

  return location;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (Source*) parseSource:(NSDictionary*)data {

  Source* source = [[Source alloc] init];

  source.code         = [data objectForKey:@"code"];
  source.name         = [data objectForKey:@"name"];
  source.logoURL      = [data objectForKey:@"logo_url"];
  source.smallLogoURL = [data objectForKey:@"logo_sm_url"];

  return source;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
