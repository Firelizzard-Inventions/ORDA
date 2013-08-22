//
//  ORDADriverErrorResult.m
//  ORDA
//
//  Created by Ethan Reesor on 8/13/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDADriverResult.h"

#import "ORDA.h"
#import "ORDADriver.h"
#import "ORDAErrorResult.h"

@implementation ORDADriverResult

+ (ORDADriverResult *)driverWithCode:(ORDADriverCode)code forDriver:(id<ORDADriver>)driver andProtocol:(Protocol *)protocol
{
	return [[[self alloc] initWithCode:code forDriver:driver andProtocol:protocol] autorelease];
}

- (id)initWithCode:(ORDADriverCode)code forDriver:(id<ORDADriver>)driver andProtocol:(Protocol *)protocol
{
	// super init as usual
	if (!(self = [super initWithCode:(ORDAResultCode)code andProtocol:protocol]))
		return nil;
	
	// driver shouldn't be nil
	if (driver == nil)
		return (ORDADriverResult *)[ORDAErrorResult errorWithCode:kORDANilDriverErrorResultCode andProtocol:nil].retain;
	
	_driver = [driver retain];
	
	return self;
}

- (void)dealloc
{
	[_driver release];
	
	[super dealloc];
}

@end
