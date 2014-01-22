//
//  ORDATableImpl.m
//  ORDA
//
//  Created by Ethan Reesor on 8/24/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDATableImpl.h"

#import <TypeExtensions/TypeExtensions.h>

#import "ORDAGovernor.h"
#import "ORDAErrorResult.h"
#import "ORDATableViewImpl.h"

SUPPRESS(-Wprotocol)
@implementation ORDATableImpl

+ (ORDATableImpl *)tableWithGovernor:(id<ORDAGovernor>)governor withName:(NSString *)tableName
{
	return [[self alloc] initWithGovernor:governor withName:tableName];
}

- (id)initWithGovernor:(id<ORDAGovernor>)governor withName:(NSString *)tableName
{
	if (!(self = [super initWithSucessCode]))
		return nil;
	
	if (!governor)
		return (ORDATableImpl *)[ORDAErrorResult errorWithCode:kORDANilGovernorErrorResultCode andProtocol:@protocol(ORDATable)];
	
	if (!tableName)
		return (ORDATableImpl *)[ORDAErrorResult errorWithCode:kORDANilTableNameErrorResultCode andProtocol:@protocol(ORDATable)];
	
	_governor = governor;
	_name = tableName;
	_rows = [NSMapTable strongToWeakObjectsMapTable];
	_views = [NSMapTable strongToWeakObjectsMapTable];
	
	return self;
}


- (id)keyForTableUpdate:(ORDATableUpdateType)type toRowWithKey:(id)key
{
	return key;
}

- (NSUInteger)nextViewID
{
	static NSUInteger _next = 0;
	
	return _next++;
}

- (id<ORDAResult>)tableUpdateDidOccur:(ORDATableUpdateType)type toRowWithKey:(id)key
{
	for (ORDATableViewImpl * view in self.views)
		[view reload];
	
	key = [self keyForTableUpdate:type toRowWithKey:key];
	
	if ([key conformsToProtocol:@protocol(ORDAResult)])
		if ([(id<ORDAResult>)key isError])
			return (id<ORDAResult>)key;
	
	switch (type) {
		case kORDARowUpdateTableUpdateType:
			[(id<ORDATableResultEntry>)self.rows[key] update];
			break;
			
		case kORDARowDeleteTableUpdateType:
			[self.rows removeObjectForKey:key];
			break;
			
		default:
			break;
	}
	
	return [ORDAErrorResult errorWithCode:kORDASucessResultCode andProtocol:nil];
}

@end
