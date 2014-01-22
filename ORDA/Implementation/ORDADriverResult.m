//
//  ORDADriverErrorResult.m
//  ORDA
//
//  Created by Ethan Reesor on 8/13/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDADriverResult.h"

#import "ORDA.h"
#import "ORDADriver.h"
#import "ORDAErrorResult.h"

@implementation ORDADriverResult

+ (ORDADriverResult *)driverWithCode:(ORDADriverCode)code forDriver:(id<ORDADriver>)driver andProtocol:(Protocol *)protocol
{
	return [[self alloc] initWithCode:code forDriver:driver andProtocol:protocol];
}

- (id)initWithCode:(ORDADriverCode)code forDriver:(id<ORDADriver>)driver andProtocol:(Protocol *)protocol
{
	// super init as usual
	if (!(self = [super initWithCode:(ORDAResultCode)code andProtocol:protocol]))
		return nil;
	
	// driver shouldn't be nil
	if (driver == nil)
		return (ORDADriverResult *)[ORDAErrorResult errorWithCode:kORDANilDriverErrorResultCode andProtocol:nil];
	
	_driver = driver;
	
	return self;
}


@end
