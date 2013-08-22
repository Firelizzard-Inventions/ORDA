//
//  ORDA.m
//  ORDA
//
//  Created by Ethan Reesor on 8/7/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDA.h"

#import "ORDADriver.h"
//#import "ORDAErrorResult.h"

@implementation ORDA {
	NSMutableDictionary * _registeredDrivers;
}

+ (BOOL)code:(ORDAResultCode)code matchesCode:(ORDACode)test withMask:(ORDAResultCodeMask)mask
{
	return (code & mask) == test;
}

+ (BOOL)code:(ORDAResultCode)code matchesClass:(ORDAResultCodeClass)class
{
	return [self code:code matchesCode:class withMask:kORDAResultCodeClassMask];
}

+ (BOOL)code:(ORDAResultCode)code matchesSubclass:(ORDAResultCodeSubclass)subclass
{
	return [self code:code matchesCode:subclass withMask:kORDAResultCodeSubclassMask];
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
//	if (!URL)
//		return (id<ORDAGovernor>)[ORDAErrorResult errorWithCode:kORDANilURLErrorResultCode andProtocol:@protocol(ORDAGovernor)];
	
	id<ORDADriver> driver = _registeredDrivers[URL.scheme];
	
//	if (!driver)
//		return (id<ORDAGovernor>)[ORDAErrorResult errorWithCode:kORDAMissingDriverErrorResultCode andProtocol:@protocol(ORDAGovernor)];
	
	NSURL * subURL = [NSURL URLWithString:URL.resourceSpecifier];
	
//	if (!subURL)
//		return (id<ORDAGovernor>)[ORDAErrorResult errorWithCode:kORDABadURLErrorResultCode andProtocol:@protocol(ORDAGovernor)];
	
	return [driver governorForURL:subURL];
}

@end
