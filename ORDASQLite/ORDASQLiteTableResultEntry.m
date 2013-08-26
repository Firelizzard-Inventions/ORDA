//
//  ORDASQLiteTableResultEntry.m
//  ORDA
//
//  Created by Ethan Reesor on 8/25/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDASQLiteTableResultEntry.h"

@implementation ORDASQLiteTableResultEntry {
	NSMutableDictionary * _backing;
}

+ (ORDASQLiteTableResultEntry *)tableResultEntryWithRowID:(NSNumber *)rowid andData:(NSDictionary *)data
{
	return [[[self alloc] initWithRowID:rowid andData:data] autorelease];
}

- (id)initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt
{
	if (!(self = [super init]))
		return nil;
	
	_backing = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys count:cnt];
	_rowid = nil;
	
	return self;
}

- (id)initWithRowID:(NSNumber *)rowid andData:(NSDictionary *)data
{
	if (!(self = [super initWithDictionary:data]))
		return nil;
	
	_rowid = rowid.retain;
	
	return self;
}

- (void)dealloc
{
	[_backing release];
	[_rowid release];
	
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

@end
