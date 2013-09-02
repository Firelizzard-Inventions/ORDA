//
//  ORDAMySQLTable.m
//  ORDA
//
//  Created by Ethan Reesor on 9/1/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAMySQLTable.h"

#import "ORDAStatement.h"
#import "ORDAStatementResult.h"
#import "ORDAMySQLGovernor.h"
#import "ORDAMySQLErrorResult.h"
#import "ORDATableResultImpl.h"
#import "ORDAMySQLTableResultEntry.h"

@implementation ORDAMySQLTable {
	id<ORDAStatement> columnNamesStatement, primaryKeyNamesStatement, foreignKeyNamesStatement;
}

- (id)initWithGovernor:(id<ORDAGovernor>)governor withName:(NSString *)tableName
{
	if (!(self = [super initWithGovernor:governor withName:tableName]))
		return nil;
	
	if (self.code != kORDASucessResultCode)
		return self;
	
	if (![governor isKindOfClass:ORDAMySQLGovernor.class])
		return (ORDAMySQLTable *)[ORDAMySQLErrorResult errorWithCode:kORDAInternalAPIMismatchErrorResultCode].retain;
	
	columnNamesStatement = [[self.governor createStatement:@"SELECT column_name FROM information_schema.columns WHERE table_name = '%@'", self.name] retain];
	primaryKeyNamesStatement = [[self.governor createStatement:@"SELECT column_name FROM information_schema.key_column_usage WHERE table_name = '%@' AND contstraint_name = 'PRIMARY'", self.name] retain];
	foreignKeyNamesStatement = [[self.governor createStatement:@"SELECT column_name FROM information_schema.key_column_usage WHERE table_name = '%@' AND referenced_table_name IS NOT NULL", self.name] retain];
	
	return self;
}

- (void)dealloc
{
	[columnNamesStatement release];
	[primaryKeyNamesStatement release];
	[foreignKeyNamesStatement release];
	
	[super dealloc];
}

- (NSArray *)columnNames
{
	return columnNamesStatement.result[@"column_name"];
}

- (NSArray *)primaryKeyNames
{
	return primaryKeyNamesStatement.result[@"column_name"];
}

- (NSArray *)foreignKeyTableNames
{
	return foreignKeyNamesStatement.result[@"column_name"];
}

- (NSString *)whereClauseForKeys:(NSArray *)keys
{
	NSArray * columns = self.primaryKeyNames;
	if (columns.count != keys.count)
		return nil;
	
	NSMutableArray * columnKeys = [NSMutableArray arrayWithCapacity:columns.count];
	for (int i = 0; i < columns.count; i++)
		[columnKeys addObject:[NSString stringWithFormat:@"'%@' = '%@'", columns[i], keys[i]]];
	
	return [columnKeys componentsJoinedByString:@" AND "];
}

- (id)selectWherePrimaryKeyEquals:(id)key
{
	return [self selectWherePrimaryKeysEqual:@[key]];
}

- (id)selectWherePrimaryKeysEqual:(NSArray *)keys
{
	if (self.rows[keys])
		return self.rows[keys];
	
	id<ORDAStatement> stmt = [self.governor createStatement:@"SELECT * FROM '%@' WHERE %@", self.name, [self whereClauseForKeys:keys]];
	if (stmt.isError)
		return nil;
	
	id<ORDAStatementResult> result = stmt.result;
	if (result.isError)
		return nil;
	if (result.rows < 1)
		return nil;
	
	return self.rows[keys] = [ORDAMySQLTableResultEntry tableResultEntryWithData:result[0] forTable:self];
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
	
	NSArray * columns = self.primaryKeyNames;
	id<ORDAStatement> stmt = [self.governor createStatement:@"SELECT %@ FROM '%@' WHERE %@", [columns componentsJoinedByString:@", "], self.name, clause];
	if (stmt.isError)
		return (id<ORDATableResult>)stmt;
	
	id<ORDAStatementResult> result = stmt.result;
	if (result.isError)
		return (id<ORDATableResult>)result;
	
	NSMutableArray * entries = [NSMutableArray arrayWithCapacity:result.rows];
	for (int i = 0; i < result.rows; i++) {
		NSMutableArray * keys = [NSMutableArray arrayWithCapacity:columns.count];
		for (NSString * column in columns)
			[keys addObject:result[i][column]];
		[entries addObject:[self selectWherePrimaryKeysEqual:entries]];
	}
	
	return [ORDATableResultImpl tableResultWithArray:entries];
}

- (id<ORDATableResult>)insertValues:(id)values
{
	NSMutableArray * _values = [NSMutableArray arrayWithCapacity:self.columnNames.count];
	for (NSString * column in self.columnNames)
		[_values addObject:[NSString stringWithFormat:@"'%@'", [values valueForKey:column]]];
	
	id<ORDAStatement> stmt = [self.governor createStatement:@"INSERT INTO '%@' VALUES (%@)", self.name, [_values componentsJoinedByString:@", "]];
	if (stmt.isError)
		return (id<ORDATableResult>)stmt;
	
	id<ORDAStatementResult> result = stmt.result;
	if (result.isError)
		return (id<ORDATableResult>)result;
	
	if (result.lastID)
		return [ORDATableResultImpl tableResultWithObject:[self selectWherePrimaryKeyEquals:@(result.lastID)]];
	
	NSMutableArray * keys = [NSMutableArray array];
	for (NSString * column in self.primaryKeyNames)
		[keys addObject:result[0][column]];
	return [ORDATableResultImpl tableResultWithObject:[self selectWherePrimaryKeysEqual:keys]];
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
	
	id<ORDAStatement> stmt = [self.governor createStatement:@"UPDATE '%@' SET [%@] = '%@' WHERE %@", self.name, column, value, clause];
	if (stmt.isError)
		return (id<ORDATableResult>)stmt;
	
	id<ORDAStatementResult> result = stmt.result;
	if (result.isError)
		return (id<ORDATableResult>)result;
	
	return [self selectWhere:@"%@", clause];
}


- (id)keyForTableUpdate:(ORDATableUpdateType)type toRowWithKey:(id)key
{
	if (![key isKindOfClass:NSArray.class])
		return @[key];
	return key;
}


@end
