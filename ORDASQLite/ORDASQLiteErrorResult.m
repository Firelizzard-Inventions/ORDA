//
//  ORDASQLiteErrorResult.m
//  ORDA
//
//  Created by Ethan Reesor on 8/13/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDASQLiteErrorResult.h"

#import "ORDASQLiteDriver.h"
#import "sqlite3.h"

@implementation ORDASQLiteErrorResult

+ (ORDADriverResult *)errorWithCode:(ORDASQLiteResultCodeError)code
{
	return [super driverWithCode:code forDriver:[ORDASQLiteDriver sharedInstance] andProtocol:nil];
}

+ (ORDASQLiteErrorResult *)errorWithCode:(ORDASQLiteResultCodeError)code andSQLiteErrorCode:(int)status
{
	return [[[self alloc] initWithCode:code andSQLiteErrorCode:status] autorelease];
}

+ (ORDASQLiteErrorResult *)errorWithSQLiteErrorCode:(int)status
{
	return [self errorWithCode:kORDASQLiteErrorResultCode andSQLiteErrorCode:status];
}

- (id)initWithCode:(ORDASQLiteResultCodeError)code andSQLiteErrorCode:(int)status
{
	if (!(self = [super initWithCode:(status == SQLITE_OK ? kORDASucessResultCode : code) forDriver:[ORDASQLiteDriver sharedInstance] andProtocol:nil]))
		return nil;
	
	_status = 0;
	
	return self;
}

@end
