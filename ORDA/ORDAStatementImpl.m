//
//  ORDAStatementImpl.m
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAStatementImpl.h"

#import <TypeExtensions/NSObject+abstractClass.h>
#import "ORDAGovernor.h"

@implementation ORDAStatementImpl {
	id<ORDAGovernor> _governor;
}

- (id)initWithGovernor:(id<ORDAGovernor>)governor withSQL:(NSString *)SQL
{
	if (!(self = [super init]))
		return nil;
	
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

- (id<ORDAStatementResult>)result
{
	[ORDAStatementImpl _subclassImplementationExceptionFromMethod:_cmd isClassMethod:NO];
	
	return nil;
}

@end
