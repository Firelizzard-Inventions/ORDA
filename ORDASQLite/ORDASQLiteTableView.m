//
//  ORDASQLiteTableView.m
//  ORDA
//
//  Created by Ethan Reesor on 11/29/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDASQLiteTableView.h"

#import <ORDA/ORDA.h>

#import "ORDASQLiteTable.h"

#define INITFAIL(ret) { [self release]; return (ORDASQLiteTableView *)ret; }

@implementation ORDASQLiteTableView {
	NSString * _name;
	id<ORDAStatement> _statement;
}

#pragma mark Genesis

+ (ORDASQLiteTableView *)viewWithTable:(ORDASQLiteTable *)table andClause:(NSString *)clause
{
	return [[[self alloc] initWithTable:table andClause:clause] autorelease];
}

- (id)initWithTable:(ORDASQLiteTable *)table andClause:(NSString *)clause
{
	if (!(self = [super initWithSucessCode]))
		return nil;
	
	_table = table.retain;
	_name = [[NSString alloc] initWithFormat:@"__ORDA__%@%lu", table.name, table.nextViewID];
	_statement = [table.governor createStatement:@"CREATE VIEW %@ SELECT [rowid] as 'rowid' FROM %@ WHERE %@", _name, table.name, clause].retain;
	_keys = nil;
	
	if (_statement.isError)
		INITFAIL(_statement);
	
	id<ORDAResult> result = _statement.result;
	if (result.isError)
		INITFAIL(result);
	
	[_statement release];
	_statement = [table.governor createStatement:@"SELECT * FROM %@", _name].retain;
	if (_statement.isError)
		INITFAIL(_statement);
	
	result = _statement.result;
	if (result.isError)
		INITFAIL(result);
	
	_keys = [result[@"rowid"] retain];
	
	return self;
}

- (void)dealloc
{
	[_keys release];
	[_statement release];
	
	_statement = [self.table.governor createStatement:@"DROP VIEW %@", _name];
	if (!_statement.isError)
		[_statement result];
	
	[_name release];
	[_table release];
	
	[super dealloc];
}

#pragma mark Accessors

- (NSUInteger)count
{
	return [self.keys count];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
	return [self.table selectWhereRowidEquals:self.keys[idx]];
}

#pragma mark Maintinence

- (void)reload
{
	[_statement reset];
	
	id<ORDAStatementResult> result = _statement.result;
	if (result.isError)
		return;
	
	NSArray * keys = result[@"rowid"];
	if ([self.keys isEqual:keys])
		return;
	
	BOOL countChanging = self.keys.count != keys.count;
	
	[self willChangeValueForKey:@"self"];
	[self willChangeValueForKey:@"keys"];
	if (countChanging) [self willChangeValueForKey:@"count"];
	[self.keys release];
	_keys = keys.retain;
	if (countChanging) [self didChangeValueForKey:@"count"];
	[self didChangeValueForKey:@"keys"];
	[self didChangeValueForKey:@"self"];
	
	[super reload];
}

@end
