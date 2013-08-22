//
//  ORDASQLiteGovernorImpl.m
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDASQLiteGovernor.h"

#import "ORDADriverResult.h"
#import "ORDASQLiteConsts.h"
#import "ORDASQLiteDriver.h"
#import "ORDASQLiteErrorResult.h"
#import "ORDASQLiteStatement.h"

@implementation ORDASQLiteGovernor

- (id)initWithURL:(NSURL *)URL
{
	if (!(self = [super init]))
		return nil;
	
	if (self.code != kORDASucessResultCode)
		return self;
	
	if (!URL)
		return (ORDASQLiteGovernor *)[ORDASQLiteErrorResult errorWithCode:kORDANilURLErrorResultCode].retain;
	
	NSString * path = URL.relativePath;
	if (!path)
		return (ORDASQLiteGovernor *)[ORDASQLiteErrorResult errorWithCode:kORDABadURLErrorResultCode].retain;
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:path])
		return (ORDASQLiteGovernor *)[ORDASQLiteErrorResult errorWithCode:kORDASQLiteFileDoesNotExistErrorResultCode].retain;
	
	int status = sqlite3_open([path cStringUsingEncoding:NSUTF8StringEncoding], &_connection);
	if (status != SQLITE_OK)
		return (ORDASQLiteGovernor *)[ORDASQLiteErrorResult errorWithCode:(ORDACode)kORDAConnectionErrorResultCode andSQLiteErrorCode:status].retain;
	
	return self;
}

- (void)dealloc
{
	if (_connection)
		sqlite3_close(_connection);
	
	[super dealloc];
}

- (id<ORDAStatement>)createStatement:(NSString *)statementSQL
{
	return [ORDASQLiteStatement statementWithGovernor:self withSQL:statementSQL];
}

@end
