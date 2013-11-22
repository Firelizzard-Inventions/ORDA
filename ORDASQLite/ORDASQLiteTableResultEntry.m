//
//  ORDASQLiteTableResultEntry.m
//  ORDA
//
//  Created by Ethan Reesor on 8/25/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDASQLiteTableResultEntry.h"

#import "ORDAGovernor.h"
#import "ORDAStatement.h"
#import "ORDAStatementResult.h"
#import "ORDATable.h"
#import "ORDATableResult.h"
#import "ORDASQLiteTable.h"
#import "ORDASQLiteErrorResult.h"

@implementation ORDASQLiteTableResultEntry {
	NSMutableDictionary * _backing;
	NSDictionary * _locks;
}

+ (ORDASQLiteTableResultEntry *)tableResultEntryWithRowID:(NSNumber *)rowid andData:(NSDictionary *)data forTable:(id<ORDATable>)table
{
	return [[[self alloc] initWithRowID:rowid andData:data forTable:table] autorelease];
}

- (id)initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt
{
	if (!(self = [super init]))
		return nil;
	
	_backing = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys count:cnt];
	_rowid = nil;
	_table = nil;
	
	id locks[cnt];
	for (int i = 0; i < cnt; i++)
		locks[i] = [[[NSLock alloc] init] autorelease];
	_locks = [[NSDictionary alloc] initWithObjects:locks forKeys:keys count:cnt];
	
	for (id key in _backing)
		[self addObserver:self forKeyPath:[key description] options:NSKeyValueObservingOptionNew context:nil];
	
	return self;
}

- (id)initWithRowID:(NSNumber *)rowid andData:(NSDictionary *)data forTable:(id<ORDATable>)table
{
	if (!(self = [super initWithDictionary:data]))
		return nil;
	
	if (![table isKindOfClass:ORDASQLiteTable.class])
		return nil;
	
	_rowid = rowid.retain;
	_table = table.retain;
	
	[self addObserver:self forKeyPath:@"rowid" options:NSKeyValueObservingOptionNew context:nil];
	
	return self;
}

- (void)dealloc
{
	if (_rowid)
		[self removeObserver:self forKeyPath:@"rowid" context:nil];
	
	for (id key in _backing)
		[self removeObserver:self forKeyPath:[key description] context:nil];
	
	[_table release];
	[_rowid release];
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
	id<ORDAStatement> stmt = [((ORDATableImpl *)self.table).governor createStatement:@"SELECT * FROM %@ WHERE rowid = %@", self.table.name, self.rowid];
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
	
	id<ORDATableResult> result = [self.table updateSet:keyPath to:change[NSKeyValueChangeNewKey] where:@"rowid = '%@'", self.rowid];
	if (result.isError)
		; // TODO do something with this error
	
	[lock unlock];
}

@end
