//
//  ORDA.m
//  ORDA
//
//  Created by Ethan Reesor on 8/7/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDA.h"

#import "ORDADriver.h"
#import "ORDAErrorResult.h"

@implementation ORDA {
	NSMutableDictionary * _registeredDrivers;
}

- (id)init {
	static ORDA * _shared = nil;
	
	@synchronized([ORDA class]) {
		if (_shared == nil) {
			if (!(_shared = self = [super init]))
				return nil;
			
			_registeredDrivers = @{}.mutableCopy;
		}
	}
	
	return _shared;
}

- (void)dealloc
{
	[_registeredDrivers dealloc];
	
	[super dealloc];
}

- (NSArray *)registeredDrivers
{
	return [_registeredDrivers allValues];
}

- (void)registerDriver:(id<ORDADriver>)driver
{
	_registeredDrivers[[driver scheme]] = driver;
}

- (id<ORDAGovernor>)governorForURL:(NSURL *)URL
{
	if (!URL)
		return (id<ORDAGovernor>)[[ORDAErrorResult alloc] initWithCode:kORDANilURLErrorResultCode];
	
	id<ORDADriver> driver = _registeredDrivers[[URL scheme]];
	
	if (!driver)
		return (id<ORDAGovernor>)[[ORDAErrorResult alloc] initWithCode:kORDAMissingDriverErrorResultCode];
	
	NSURL * subURL = [NSURL URLWithString:[URL resourceSpecifier]];
	
	if (!subURL)
		return (id<ORDAGovernor>)[[ORDAErrorResult alloc] initWithCode:kORDABadURLErrorResultCode];
	
	return [driver governorForURL:subURL];
}

@end
