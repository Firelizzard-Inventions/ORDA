//
//  ORDAStatementImpl.m
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDAStatementImpl.h"

#import "ORDAGovernor.h"
#import "ORDAErrorResult.h"

SUPPRESS(-Wprotocol)
@implementation ORDAStatementImpl

+ (ORDAStatementImpl *)statementWithGovernor:(id<ORDAGovernor>)governor withSQL:(NSString *)SQL
{
	return [[self alloc] initWithGovernor:governor withSQL:SQL];
}

- (id)initWithGovernor:(id<ORDAGovernor>)governor withSQL:(NSString *)SQL
{
	if (!(self = [super initWithSucessCode]))
		return nil;
	
	if (!governor)
		return (ORDAStatementImpl *)[ORDAErrorResult errorWithCode:kORDANilGovernorErrorResultCode andProtocol:@protocol(ORDAStatement)];
	
	if (!SQL)
		return (ORDAStatementImpl *)[ORDAErrorResult errorWithCode:kORDANilStatementSQLErrorResultCode andProtocol:@protocol(ORDAStatement)];
	
	_governor = governor;
	_statementSQL = SQL.copy;
	
	return self;
}

- (id<NSFastEnumeration>)fastEnumerate
{
	return self;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
	if (!state->state) {
		state->mutationsPtr = (unsigned long *)(__bridge void *)self;
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