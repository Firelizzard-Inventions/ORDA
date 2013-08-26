//
//  ORDAStatementImpl.m
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDAStatementImpl.h"

//#import <TypeExtensions/NSObject+abstractProtocolConformer.h>
#import "ORDAGovernor.h"
#import "ORDAErrorResult.h"

#pragma clang diagnostic ignored "-Wprotocol"
@implementation ORDAStatementImpl

+ (ORDAStatementImpl *)statementWithGovernor:(id<ORDAGovernor>)governor withSQL:(NSString *)SQL
{
	return [[[self alloc] initWithGovernor:governor withSQL:SQL] autorelease];
}

- (id)initWithGovernor:(id<ORDAGovernor>)governor withSQL:(NSString *)SQL
{
	if (!(self = [super initWithSucessCode]))
		return nil;
	
	if (!governor)
		return (ORDAStatementImpl *)[ORDAErrorResult errorWithCode:kORDANilGovernorErrorResultCode andProtocol:@protocol(ORDAStatement)].retain;
	
	if (!SQL)
		return (ORDAStatementImpl *)[ORDAErrorResult errorWithCode:kORDANilStatementSQLErrorResultCode andProtocol:@protocol(ORDAStatement)].retain;
	
	_governor = governor.retain;
	_statementSQL = SQL.copy;
	
	return self;
}

- (void)dealloc
{
	[_governor release];
	[_statementSQL release];
	
	[super dealloc];
}

- (id<NSFastEnumeration>)fastEnumerate
{
	return self;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id [])buffer count:(NSUInteger)len
{
	if (!state->state) {
		state->mutationsPtr = (unsigned long *)self;
		state->extra[0] = (long)self;
		state->state++;
	}
	
	NSUInteger count;
	id<ORDAStatement> current = (id<ORDAStatement>)self;
	
	for (count = 0; count < len && current; count++, current = current.nextStatement)
		buffer[count] = current;
	
	state->extra[0] = (long)current;
	
	return count;
}

@end
