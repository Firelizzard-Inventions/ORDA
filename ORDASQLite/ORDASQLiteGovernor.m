//
//  ORDASQLiteGovernorImpl.m
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDASQLiteGovernor.h"

#import <ORDA/ORDA.h>

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

- (id<ORDAStatement>)createStatement:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)
{
	va_list args;
	va_start(args, format);
	NSString * statementSQL = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
	va_end(args);
	
	return [ORDASQLiteStatement statementWithGovernor:self withSQL:statementSQL];
}

- (NSArray *)columnNamesForTableName:(NSString *)tableName
{
	return [self createStatement:@"PRAGMA table_info(%@)", tableName].result[@"name"];
}

- (NSArray *)primaryKeyNamesForTableName:(NSString *)tableName
{
	id<ORDAStatementResult> result = [self createStatement:@"PRAGMA table_info(%@)", tableName].result;
	if (!result || result.isError)
		return nil;
	
	NSMutableArray * keys = [NSMutableArray array];
	for (int i = 0; i < result.rows; i++)
		if (((NSNumber *)result[i][@"pk"]).boolValue)
			[keys addObject:result[i][@"name"]];
	
	return [NSArray arrayWithArray:keys];
}

- (NSArray *)foreignKeyTableNamesForTableName:(NSString *)tableName
{
	return [self createStatement:@"PRAGMA foreign_key_list(%@)", tableName].result[@"table"];
}

@end
