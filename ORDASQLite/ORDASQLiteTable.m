//
//  ORDASQLiteTable.m
//  ORDA
//
//  Created by Ethan Reesor on 8/24/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDASQLiteTable.h"

#import <TypeExtensions/NSMutableDictionary_NonRetaining_Zeroing.h>

#import "ORDAStatement.h"
#import "ORDAStatementResult.h"
#import "ORDASQLiteGovernor.h"
#import "ORDASQLiteErrorResult.h"
#import "ORDATableResultImpl.h"
#import "ORDASQLiteTableResultEntry.h"

@implementation ORDASQLiteTable {
	id<ORDAStatement> tableInfoStatement, foreignKeyListStatement;
}

- (id)initWithGovernor:(id<ORDAGovernor>)governor withName:(NSString *)tableName
{
	if (!(self = [super initWithGovernor:governor withName:tableName]))
		return nil;
	
	if (self.code != kORDASucessResultCode)
		return self;
	
	if (![governor isKindOfClass:[ORDASQLiteGovernor class]])
		return (ORDASQLiteTable *)[ORDASQLiteErrorResult errorWithCode:kORDAInternalAPIMismatchErrorResultCode].retain;
	
	tableInfoStatement = [self.governor createStatement:@"PRAGMA table_info(%@)", self.name].retain;
	foreignKeyListStatement = [self.governor createStatement:@"PRAGMA foreign_key_list(%@)", self.name].retain;
	
	return self;
}

- (void)dealloc
{
	[tableInfoStatement release];
	[foreignKeyListStatement release];
	
	[super dealloc];
}

- (NSArray *)columnNames
{
	return tableInfoStatement.result[@"name"];
}

- (NSArray *)primaryKeyNames
{
	id<ORDAStatementResult> result = tableInfoStatement.result;
	if (result.isError)
		return nil;
	
	NSMutableArray * keys = [NSMutableArray array];
	for (int i = 0; i < result.rows; i++)
		if (((NSNumber *)result[i][@"pk"]).boolValue)
			[keys addObject:result[i][@"name"]];
	
	return [NSArray arrayWithArray:keys];
}

- (NSArray *)foreignKeyTableNames
{
	return foreignKeyListStatement.result[@"table"];
}

- (id)selectWhereRowidEquals:(NSNumber *)rowid
{
	if (self.rows[rowid])
		return self.rows[rowid];
	
	id<ORDAStatement> stmt = [self.governor createStatement:@"SELECT * FROM [%@] WHERE rowid = '%@'", self.name, rowid];
	if (stmt.isError)
		return nil;
	
	id<ORDAStatementResult> result = stmt.result;
	if (result.isError)
		return nil;
	if (result.rows < 1)
		return nil;
	
	return self.rows[rowid] = [ORDASQLiteTableResultEntry tableResultEntryWithRowID:rowid andData:result[0] forTable:self];
}

- (id<ORDATableResult>)selectWhere:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
{
	NSString * clause = nil;
	if (!format)
		clause = @"1";
	else {
		va_list args;
		va_start(args, format);
		clause = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
		va_end(args);
	}
	
	id<ORDAStatement> stmt = [self.governor createStatement:@"SELECT rowid as 'rowid' FROM [%@] WHERE %@", self.name, clause];
	if (stmt.isError)
		return (id<ORDATableResult>)stmt;
	
	id<ORDAStatementResult> result = stmt.result;
	if (result.isError)
		return (id<ORDATableResult>)result;
	
	NSMutableArray * entries = [NSMutableArray arrayWithCapacity:result.rows];
	for (NSNumber * rowid in result[@"rowid"])
		[entries addObject:[self selectWhereRowidEquals:rowid]];
	
	return [ORDATableResultImpl tableResultWithArray:entries];
}

- (id<ORDATableResult>)insertValues:(id)values
{
	NSMutableArray * _values = [NSMutableArray arrayWithCapacity:self.columnNames.count];
	for (NSString * column in self.columnNames)
		[_values addObject:[NSString stringWithFormat:@"'%@'", [values valueForKey:column]]];
	
	id<ORDAStatement> stmt = [self.governor createStatement:@"INSERT INTO [%@] VALUES (%@)", self.name, [_values componentsJoinedByString:@", "]];
	if (stmt.isError)
		return (id<ORDATableResult>)stmt;
	
	id<ORDAStatementResult> result = stmt.result;
	if (result.isError)
		return (id<ORDATableResult>)result;
	if (result.lastID < 0)
		return (id<ORDATableResult>)[ORDASQLiteErrorResult errorWithCode:(ORDACode)kORDANoResultRowsForKeyErrorResultCode];
	
	return [ORDATableResultImpl tableResultWithObject:[self selectWhereRowidEquals:@(result.lastID)]];
}

- (id<ORDATableResult>)updateSet:(NSString *)column to:(id)value where:(NSString *)format, ... NS_FORMAT_FUNCTION(1,4);
{
	NSString * clause = nil;
	if (!format)
		clause = @"1";
	else {
		va_list args;
		va_start(args, format);
		clause = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
		va_end(args);
	}
	
	id<ORDAStatement> stmt = [self.governor createStatement:@"UPDATE %@ SET [%@] = '%@' WHERE %@", self.name, column, value, clause];
	if (stmt.isError)
		return (id<ORDATableResult>)stmt;
	
	id<ORDAStatementResult> result = stmt.result;
	if (result.isError)
		return (id<ORDATableResult>)result;
	
	return [self selectWhere:@"%@", clause];
}

- (id)keyForTableUpdate:(ORDATableUpdateType)type toRowWithKey:(id)key
{
	NSNumber * rowid = key;
	
	if (![rowid isKindOfClass:NSNumber.class]) {
		id<ORDAStatement> stmt = [self.governor createStatement:@"SELECT rowid as 'rowid' FROM [%@] WHERE %@", self.name, key];
		if (stmt.isError)
			return stmt;
		
		id<ORDAStatementResult> result = stmt.result;
		if (result.isError)
			return result;
		if (result.rows < 1)
			return (id<ORDATableResult>)[ORDASQLiteErrorResult errorWithCode:(ORDACode)kORDANoResultRowsForKeyErrorResultCode];
		
		rowid = result[0][@"rowid"];
	}
	
	return rowid;
}

@end
