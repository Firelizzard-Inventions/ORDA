//
//  ORDAErrorResult.m
//  ORDA
//
//  Created by Ethan Reesor on 8/20/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDAErrorResult.h"

#import "ORDA.h"

@implementation ORDAErrorResult

+ (ORDAErrorResult *)errorWithCode:(ORDAResultCode)code andProtocol:(Protocol *)protocol
{
	return [[self alloc] initWithCode:code andProtocol:protocol];
}

- (id)initWithCode:(ORDAResultCode)code andProtocol:(Protocol *)protocol
{
	if (!(self = [super initWithProtocol:protocol]))
		return nil;
	
	if (code == kORDASucessResultCode)
		return nil;
	
	_code = code;
	
	return self;
}

- (BOOL)isError
{
	return YES;
}

@end
