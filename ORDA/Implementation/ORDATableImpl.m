//
//  ORDATableImpl.m
//  ORDA
//
//  Created by Ethan Reesor on 8/24/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDATableImpl.h"

//#import <TypeExtensions/NSObject+abstractProtocolConformer.h>
#import "ORDAGovernor.h"
#import "ORDAErrorResult.h"
#import <TypeExtensions/NSMutableDictionary_NonRetaining_Zeroing.h>

#pragma clang diagnostic ignored "-Wprotocol"
@implementation ORDATableImpl

+ (ORDATableImpl *)tableWithGovernor:(id<ORDAGovernor>)governor withName:(NSString *)tableName
{
	return [[[self alloc] initWithGovernor:governor withName:tableName] autorelease];
}

- (id)initWithGovernor:(id<ORDAGovernor>)governor withName:(NSString *)tableName
{
	if (!(self = [super initWithSucessCode]))
		return nil;
	
	if (!governor)
		return (ORDATableImpl *)[ORDAErrorResult errorWithCode:kORDANilGovernorErrorResultCode andProtocol:@protocol(ORDATable)].retain;
	
	if (!tableName)
		return (ORDATableImpl *)[ORDAErrorResult errorWithCode:kORDANilTableNameErrorResultCode andProtocol:@protocol(ORDATable)].retain;
	
	_governor = governor.retain;
	_name = tableName.retain;
	_rows = [[NSMutableDictionary_NonRetaining_Zeroing dictionary] retain];
	
	return self;
}

- (void)dealloc
{
	[_governor release];
	[_name release];
	
	[super dealloc];
}

- (id)keyForTableUpdate:(ORDATableUpdateType)type toRowWithKey:(id)key
{
	return key;
}

- (id<ORDAResult>)tableUpdateDidOccur:(ORDATableUpdateType)type toRowWithKey:(id)key
{
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
