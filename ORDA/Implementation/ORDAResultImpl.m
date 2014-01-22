//
//  ORDAResultImpl.m
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDAResultImpl.h"

#import "ORDA.h"
#import "ORDA+Private.h"

@implementation ORDAResultImpl

+ (ORDAResultImpl *)resultWithCode:(ORDAResultCode)code
{
	return [[self alloc] initWithCode:code];
}

- (id)init
{
	return nil;
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

- (NSString *)description
{
	return [NSString stringWithFormat:@"<Result: %@>", [ORDA descriptionForCode:self.code]];
}

@end
