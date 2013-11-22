//
//  ORDAMySQLTableResultEntry.m
//  ORDA
//
//  Created by Ethan Reesor on 9/2/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAMySQLTableResultEntry.h"

#import "ORDAMySQLTable.h"
#import "ORDAGovernor.h"
#import "ORDAStatement.h"
#import "ORDAStatementResult.h"
#import "ORDATableResult.h"

@implementation ORDAMySQLTableResultEntry {
	NSMutableDictionary * _backing;
	NSDictionary * _locks;
}

+ (ORDAMySQLTableResultEntry *)tableResultEntryWithData:(NSDictionary *)data forTable:(id<ORDATable>)table
{
	return [[[self alloc] initWithData:data forTable:table] autorelease];
}

- (id)initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt
{
	if (!(self = [super init]))
		return nil;
	
	_backing = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys count:cnt];
	_table = nil;
	
	id locks[cnt];
	for (int i = 0; i < cnt; i++)
		locks[i] = [[[NSLock alloc] init] autorelease];
	_locks = [[NSDictionary alloc] initWithObjects:locks forKeys:keys count:cnt];
	
	for (id key in _backing)
		[self addObserver:self forKeyPath:[key description] options:NSKeyValueObservingOptionNew context:nil];
	
	return self;
}

- (id)initWithData:(NSDictionary *)data forTable:(id<ORDATable>)table
{
	if (!(self = [super initWithDictionary:data]))
		return nil;
	
	if (![table isKindOfClass:ORDAMySQLTable.class])
		return nil;
	
	_table = table.retain;
	
	return self;
}

- (void)dealloc
{
	for (id key in _backing)
		[self removeObserver:self forKeyPath:[key description] context:nil];
	
	[_table release];
	[_locks release];
	[_backing release];
	
	[super dealloc];
}

- (NSArray *)exposedBindings
{
	return _backing.allKeys;
}

- (NSUInteger)count
{
	return _backing.count;
}

- (id)objectForKey:(id)aKey
{
	return [_backing objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator
{
	return _backing.keyEnumerator;
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
	[_backing setObject:anObject forKey:aKey];
}

- (void)removeObjectForKey:(id)aKey
{
	[_backing removeObjectForKey:aKey];
}

- (void)update
{
	NSMutableArray * columnKeys = [NSMutableArray array];
	for (NSString * column in self.table.foreignKeyTableNames)
		[columnKeys addObject:[NSString stringWithFormat:@"'%@' = '%@'", column, [self valueForKey:column]]];
	
	id<ORDAStatement> stmt = [((ORDATableImpl *)self.table).governor createStatement:@"SELECT * FROM %@ WHERE %@", self.table.name, [columnKeys componentsJoinedByString:@" AND "]];
	if (stmt.isError)
		return;
	
	id<ORDAStatementResult> result = stmt.result;
	if (result.isError)
		return;
	if (result.rows < 1)
		return;
	
	NSDictionary * newData = result[0];
	for (id key in newData)
		if (![[self valueForKey:key] isEqual:newData[key]]) {
			NSLock * lock = _locks[key];
			if (![lock tryLock])
				continue;
			
			[self setValue:newData[key] forKey:key];
			[lock unlock];
		}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (object != self)
		return;
	
	NSLock * lock = _locks[keyPath];
	if (![lock tryLock])
		return;
	
	NSMutableArray * columnKeys = [NSMutableArray array];
	for (NSString * column in self.table.foreignKeyTableNames)
		[columnKeys addObject:[NSString stringWithFormat:@"'%@' = '%@'", column, [self valueForKey:column]]];
	
	id<ORDATableResult> result = [self.table updateSet:keyPath to:change[NSKeyValueChangeNewKey] where:@"%@", [columnKeys componentsJoinedByString:@" AND "]];
	if (result.isError)
		return;
	
	[lock unlock];
}

@end
