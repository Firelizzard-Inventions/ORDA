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
	NSMutableDictionary * rows;
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
	
	rows = [[NSMutableDictionary_NonRetaining_Zeroing dictionary] retain];
	
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
	if (rows[rowid])
		return rows[rowid];
	
	id<ORDAStatement> stmt = [self.governor createStatement:@"SELECT * FROM [%@] WHERE rowid = '%@'", self.name, rowid];
	if (stmt.isError)
		return nil;
	
	id<ORDAStatementResult> result = stmt.result;
	if (result.isError)
		return nil;
	if (result.rows < 1)
		return nil;
	
	return rows[rowid] = [ORDASQLiteTableResultEntry tableResultEntryWithRowID:rowid andData:result[0]];
}

- (id<ORDATableResult>)selectWhere:(NSString *)clause
{
	if (!clause)
		clause = @"1";
	
	id<ORDAStatement> stmt = [self.governor createStatement:@"SELECT rowid as 'rowid' FROM %@ WHERE %@", self.name, clause];
	if (stmt.isError)
		return nil;
	
	id<ORDAStatementResult> result = stmt.result;
	if (result.isError)
		return nil;
	
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
	
	id<ORDAStatement> stmt = [self.governor createStatement:@"INSERT INTO %@ VALUES (%@)", self.name, [_values componentsJoinedByString:@", "]];
	if (stmt.isError)
		return nil;
	
	id<ORDAStatementResult> result = stmt.result;
	if (result.isError)
		return nil;
	if (result.lastID < 0)
		return nil;
	
	return [ORDATableResultImpl tableResultWithObject:[self selectWhereRowidEquals:@(result.lastID)]];
}

- (id<ORDATableResult>)updateSet:(NSString *)column to:(id)value where:(NSString *)clause
{
	if (!clause)
		clause = @"1";
	
	id<ORDAStatement> stmt = [self.governor createStatement:@"UPDATE %@ SET [%@] = '%@' WHERE %@", self.name, column, value, clause];
	if (stmt.isError)
		return nil;
	
	id<ORDAStatementResult> result = stmt.result;
	if (result.isError)
		return nil;
	
	return [self selectWhere:clause];
}

- (void)updateDidOccur:(int)update toRowID:(NSNumber *)rowid
{
	switch (update) {
		case SQLITE_INSERT:
			break;
			
		case SQLITE_UPDATE:
			;
			id entry = rows[rowid];
			
			if (!entry)
				break;
			
			id<ORDAStatement> stmt = [self.governor createStatement:@"SELECT * FROM %@ WHERE rowid = %@", self.name, rowid];
			if (stmt.isError)
				break;
			
			id<ORDAStatementResult> result = stmt.result;
			if (result.isError)
				break;
			if (result.rows < 1)
				break;
			
			NSDictionary * newData = result[0];
			for (id key in newData)
				if (![[entry valueForKey:key] isEqual:newData[key]])
					[entry setValue:newData[key] forKey:key];
			
			break;
			
		case SQLITE_DELETE:
			[rows removeObjectForKey:rowid];
			break;
	}
}

@end
