//  StatusAPIClient.m
//  threetapsAPI
//
//  Created by Erik Westra on 13/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "JSON.h"

#import "StatusAPIClient.h"

#import "APIConnection.h"
#import "APIData.h"
#import "APIError.h"
#import "Posting.h"

// ################################################################################################
//
// Private method definitions:

@interface StatusAPIClient (private)

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// updateStatusFinishedWith:
//
//    Respond to our 'updateStatus' API call finishing or failing.

- (void) updateStatusFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getStatusHistoryFinishedWith:
//
//    Respond to our 'getStatusHistory' API call finishing or failing.

- (void) getStatusHistoryFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// getSystemStatusFinishedWith:
//
//    Respond to our 'getSystemStatus' API call finishing or failing.

- (void) getSystemStatusFinishedWith:(APIConnection*)connection;

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################

@implementation StatusAPIClient

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

- (void) setDelegate:(<StatusAPIClientDelegate>)delegate {

  self._delegate = delegate;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) updateStatus:(NSArray*)updates {

  NSMutableArray* eventData = [[NSMutableArray alloc] init];

  for (StatusUpdate* update in updates) {
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];

    if (update.status == StatusUpdateStatusFound) {
      [data setObject:@"found" forKey:@"status"];
    } else if (update.status == StatusUpdateStatusGot) {
      [data setObject:@"got" forKey:@"status"];
    } else if (update.status == StatusUpdateStatusProcessed) {
      [data setObject:@"processed" forKey:@"status"];
    } else if (update.status == StatusUpdateStatusSent) {
      [data setObject:@"sent" forKey:@"status"];
    } else if (update.status == StatusUpdateStatusReceived) {
      [data setObject:@"received" forKey:@"status"];
    } else if (update.status == StatusUpdateStatusIndexed) {
      [data setObject:@"indexed" forKey:@"status"];
    }

    if (update.externalID != nil) {
      [data setObject:update.externalID forKey:@"externalID"];
    }

    if (update.source != nil) {
      [data setObject:update.source forKey:@"source"];
    }

    if (update.timestamp != nil) {
      NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
      [formatter setDateFormat:@"yyyy'/'MM'/'dd' 'hh':'mm':'ss' UTC'"];
      [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
      [data setObject:[formatter stringFromDate:update.timestamp]
               forKey:@"timestamp"];
      [formatter release];
    }

    if ((update.attributes != nil) && ([update.attributes count] > 0)) {
      [data setObject:update.attributes forKey:@"attributes"];
    }

    [eventData addObject:data];
  }

  SBJsonWriter* writer = [[SBJsonWriter alloc] init];
  NSString* jsonData = [writer stringWithObject:eventData];
  [writer release];

  NSDictionary* args = [NSDictionary dictionaryWithObject:jsonData forKey:@"events"];

  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"status/update"]];
  [connection setFormValues:args];
  [connection setTarget:self
           withSelector:@selector(updateStatusFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];

  [connection release];
  [eventData  release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getStatusHistory:(NSArray*)postings {

  NSMutableArray* postingData = [[NSMutableArray alloc] init];
  for (Posting* posting in postings) {
    [postingData addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            posting.externalID, @"externalID",
                            posting.source,     @"source",
                            nil]];
  }

  SBJsonWriter* writer = [[SBJsonWriter alloc] init];
  NSString* jsonData = [writer stringWithObject:postingData];
  [writer release];

  NSDictionary* args = [NSDictionary dictionaryWithObject:jsonData forKey:@"postings"];

  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"status/get"]];
  [connection setFormValues:args];
  [connection setTarget:self
           withSelector:@selector(getStatusHistoryFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];

  [connection  release];
  [postingData release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getSystemStatus {

  APIConnection* connection = [[APIConnection alloc] init];
  [connection setURL:[self getURL:@"status/system"]];
  [connection setTarget:self
           withSelector:@selector(getSystemStatusFinishedWith:)];
  [connection start];
  [self connectionStarted:connection];

  [connection  release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                 P R I V A T E   M E T H O D S                                 //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) updateStatusFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate statusUpdateFailedWithError:results.error];
    [results release];
    return;
  }

  [self._delegate statusUpdated];
  [results release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getStatusHistoryFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate getStatusHistoryFailedWithError:results.error];
    [results release];
    return;
  }

  NSMutableArray* histories = [[NSMutableArray alloc] init];

  for (NSDictionary* entry in (NSArray*)results.data) {
    NSMutableDictionary* history = [[NSMutableDictionary alloc] init];
    [history setObject:[entry objectForKey:@"externalID"] forKey:@"externalID"];
    [history setObject:[entry objectForKey:@"source"]     forKey:@"source"];
    [history setObject:[entry objectForKey:@"exists"]     forKey:@"exists"];

    NSMutableDictionary* statuses = [[NSMutableDictionary alloc] init];

    for (NSString* status in [[entry objectForKey:@"history"] keyEnumerator]) {
      NSArray* statusUpdates = [[entry objectForKey:@"history"] objectForKey:status];

      StatusUpdateStatus statusValue;
      if ([status isEqualToString:@"found"]) {
        statusValue = StatusUpdateStatusFound;
      } else if ([status isEqualToString:@"got"]) {
        statusValue = StatusUpdateStatusGot;
      } else if ([status isEqualToString:@"processed"]) {
        statusValue = StatusUpdateStatusProcessed;
      } else if ([status isEqualToString:@"sent"]) {
        statusValue = StatusUpdateStatusSent;
      } else if ([status isEqualToString:@"received"]) {
        statusValue = StatusUpdateStatusReceived;
      } else if ([status isEqualToString:@"indexed"]) {
        statusValue = StatusUpdateStatusIndexed;
      } else {
        statusValue = StatusUpdateStatusNone;
      }

      NSMutableArray* updates = [[NSMutableArray alloc] init];
      for (NSDictionary* statusUpdate in statusUpdates) {
        NSMutableDictionary* update = [[NSMutableDictionary alloc] init];

        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy'/'MM'/'dd' 'hh':'mm':'ss' UTC'"];
        [update setObject:[formatter dateFromString:[statusUpdate objectForKey:@"timestamp"]]
                   forKey:@"timestamp"];
        [formatter release];

        if ([statusUpdate objectForKey:@"errors"] != nil) {
          [update setObject:[statusUpdate objectForKey:@"errors"]
                     forKey:@"errors"];
        }
        if ([statusUpdate objectForKey:@"attributes"] != nil) {
          [update setObject:[statusUpdate objectForKey:@"attributes"]
                     forKey:@"attributes"];
        }

        [updates addObject:update];
        [update release];
      }

      [statuses setObject:updates forKey:[NSNumber numberWithInt:statusValue]];
    }
    [history setObject:statuses forKey:@"statuses"];

    [histories addObject:history];
  }

  [self._delegate gotStatusHistory:histories];
  [results release];
  [histories release];
};

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) getSystemStatusFinishedWith:(APIConnection*)connection {

  [self connectionStopped:connection];

  APIData* results = [[APIData alloc] initWithConnection:connection];
  if (!results.valid) {
    [self._delegate getSystemStatusFailedWithError:results.error];
    [results release];
    return;
  }

  NSDictionary* status = (NSDictionary*)results.data;
  
  [self._delegate gotSystemStatusCode:[[status objectForKey:@"code"] intValue]
                              message:[status objectForKey:@"message"]];

  [results release];
};

///////////////////////////////////////////////////////////////////////////////////////////////////

@end

// ################################################################################################

@implementation StatusUpdate

@synthesize status;
@synthesize externalID;
@synthesize source;
@synthesize timestamp;
@synthesize attributes;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init {

  if (self = [super init]) {
    self.status     = StatusUpdateStatusNone;
    self.externalID = nil;
    self.source     = nil;
    self.timestamp  = nil;
    self.attributes = nil;
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void) dealloc {

  [self.externalID release];
  [self.source     release];
  [self.timestamp  release];
  [self.attributes release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
