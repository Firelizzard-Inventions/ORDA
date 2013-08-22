//
//  ORDAResultImpl.m
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDAResultImpl.h"

#import "ORDA.h"

@implementation ORDAResultImpl

+ (ORDAResultImpl *)resultWithCode:(ORDAResultCode)code
{
	return [[[self alloc] initWithCode:code] autorelease];
}

- (id)initWithCode:(ORDAResultCode)code
{
	if (!(self = [super init]))
		return nil;
	
	_code = code;
	
	return self;
}

- (id)initWithSucessCode
{
	return [self initWithCode:kORDASucessResultCode];
}

- (BOOL)isError
{
	return [ORDA code:self.code matchesClass:kORDAResultCodeErrorClass];
}

@end
