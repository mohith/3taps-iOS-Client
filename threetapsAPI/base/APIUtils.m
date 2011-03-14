//  APIUtils.m
//  threetapsAPI
//
//  Created by Erik Westra on 15/03/11.
//  Copyright (c) 2011, 3taps inc.  All rights reserved.

#import "APIUtils.h"

// ################################################################################################

@implementation APIUtils

///////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSDate*) convertToUTC:(NSDate*)sourceDate {

  NSTimeZone* currentTimeZone = [NSTimeZone localTimeZone];
  NSTimeZone* utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
  
  NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:sourceDate];
  NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:sourceDate];
  NSTimeInterval gmtInterval = gmtOffset - currentGMTOffset;
  
  NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:gmtInterval
                                                        sinceDate:sourceDate] autorelease];
  return destinationDate;
}

//////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSDate*) convertFromUTC:(NSDate*)sourceDate {
  
  NSTimeZone* currentTimeZone = [NSTimeZone localTimeZone];
  NSTimeZone* utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
  
  NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:sourceDate];
  NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:sourceDate];
  NSTimeInterval gmtInterval = gmtOffset - currentGMTOffset;
  
  NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:-gmtInterval
                                                        sinceDate:sourceDate] autorelease];
  return destinationDate;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSDictionary*) postingToDictionary:(Posting*)posting {

  NSMutableDictionary* postDict = [[NSMutableDictionary alloc] init];
  
  if (posting.postKey != nil) {
    [postDict setObject:posting.postKey forKey:@"postKey"];
  }

  if (posting.location != nil) {
    [postDict setObject:posting.location forKey:@"location"];
  }

  if (posting.category != nil) {
    [postDict setObject:posting.category forKey:@"category"];
  }

  if (posting.source != nil) {
    [postDict setObject:posting.source forKey:@"source"];
  }

  if (posting.heading != nil) {
    [postDict setObject:posting.heading forKey:@"heading"];
  }

  if (posting.body != nil) {
    [postDict setObject:posting.body forKey:@"body"];
  }

  if (posting.latitude != nil) {
    [postDict setObject:posting.latitude forKey:@"latitude"];
  }

  if (posting.longitude != nil) {
    [postDict setObject:posting.longitude forKey:@"longitude"];
  }

  if (posting.language != nil) {
    [postDict setObject:posting.language forKey:@"language"];
  }

  if (posting.price != nil) {
    [postDict setObject:posting.price forKey:@"price"];
  }

  if (posting.currency != nil) {
    [postDict setObject:posting.currency forKey:@"currency"];
  }

  if ((posting.images != nil) && ([posting.images count] > 0)) {
    [postDict setObject:posting.images forKey:@"images"];
  }

  if (posting.externalURL != nil) {
    [postDict setObject:posting.externalURL forKey:@"externalURL"];
  }

  if (posting.externalID != nil) {
    [postDict setObject:posting.externalID forKey:@"externalID"];
  }

  if (posting.accountName != nil) {
    [postDict setObject:posting.accountName forKey:@"accountName"];
  }

  if (posting.accountID != nil) {
    [postDict setObject:posting.accountID forKey:@"accountID"];
  }

  if (posting.timestamp != nil) {
    [postDict setObject:[APIUtils dateToString:posting.timestamp] forKey:@"timestamp"];
  }

  if (posting.expiration != nil) {
    [postDict setObject:[APIUtils dateToString:posting.expiration] forKey:@"expiration"];
  }

  if ((posting.annotations != nil) && ([posting.annotations count] > 0)) {
    [postDict setObject:posting.annotations forKey:@"annotations"];
  }

  if ((posting.trustedAnnotations != nil) && ([posting.trustedAnnotations count] > 0)) {
    [postDict setObject:posting.trustedAnnotations forKey:@"trustedAnnotations"];
  }

  if (posting.clickCount != nil) {
    [postDict setObject:posting.clickCount forKey:@"clickCount"];
  }

  return [postDict autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

+ (Posting*) dictionaryToPosting:(NSDictionary*)postDict {

  Posting* posting = [[Posting alloc] init];

  if ([postDict objectForKey:@"postKey"] != nil) {
    posting.postKey = [postDict objectForKey:@"postKey"];
  }

  if ([postDict objectForKey:@"location"] != nil) {
    posting.location = [postDict objectForKey:@"location"];
  }

  if ([postDict objectForKey:@"category"] != nil) {
    posting.category = [postDict objectForKey:@"category"];
  }

  if ([postDict objectForKey:@"source"] != nil) {
    posting.source = [postDict objectForKey:@"source"];
  }

  if ([postDict objectForKey:@"heading"] != nil) {
    posting.heading = [postDict objectForKey:@"heading"];
  }

  if ([postDict objectForKey:@"body"] != nil) {
    posting.body = [postDict objectForKey:@"body"];
  }

  if ([postDict objectForKey:@"latitude"] != nil) {
    posting.latitude = [postDict objectForKey:@"latitude"];
  }

  if ([postDict objectForKey:@"longitude"] != nil) {
    posting.longitude = [postDict objectForKey:@"longitude"];
  }

  if ([postDict objectForKey:@"price"] != nil) {
    posting.price = [postDict objectForKey:@"price"];
  }

  if ([postDict objectForKey:@"currency"] != nil) {
    posting.currency = [postDict objectForKey:@"currency"];
  }

  if ([postDict objectForKey:@"images"] != nil) {
    posting.images = [postDict objectForKey:@"images"];
  }

  if ([postDict objectForKey:@"externalURL"] != nil) {
    posting.externalURL = [postDict objectForKey:@"externalURL"];
  }

  if ([postDict objectForKey:@"externalID"] != nil) {
    posting.externalID = [postDict objectForKey:@"externalID"];
  }

  if ([postDict objectForKey:@"accountName"] != nil) {
    posting.accountName = [postDict objectForKey:@"accountName"];
  }

  if ([postDict objectForKey:@"accountID"] != nil) {
    posting.accountID = [postDict objectForKey:@"accountID"];
  }

  if ([postDict objectForKey:@"timestamp"] != nil) {
    posting.timestamp = [APIUtils stringToDate:[postDict objectForKey:@"timestamp"]];
  }

  if ([postDict objectForKey:@"expiration"] != nil) {
    posting.expiration = [APIUtils stringToDate:[postDict objectForKey:@"expiration"]];
  }

  if ([postDict objectForKey:@"annotations"] != nil) {
    posting.annotations = [postDict objectForKey:@"annotations"];
  }

  if ([postDict objectForKey:@"trustedAnnotations"] != nil) {
    posting.trustedAnnotations = [postDict objectForKey:@"trustedAnnotations"];
  }

  if ([postDict objectForKey:@"clickCount"] != nil) {
    posting.clickCount = [postDict objectForKey:@"clickCount"];
  }

  return [posting autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSDate*) stringToDate:(NSString*)string {

  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy'/'MM'/'dd' 'hh':'mm':'ss' UTC'"];
  NSDate* date = [formatter dateFromString:string];
  [formatter release];

  return date;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSString*) dateToString:(NSDate*)date {

  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy'/'MM'/'dd' 'hh':'mm':'ss' UTC'"];
  [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
  NSString* string = [formatter stringFromDate:date];
  [formatter release];

  return string;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

@end
