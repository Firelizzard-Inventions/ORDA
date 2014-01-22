//
//  ORDA.m
//  ORDA
//
//  Created by Ethan Reesor on 8/7/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDA.h"
#import "ORDA+Private.h"

#import "ORDAErrorResult.h"

@implementation ORDA {
	NSMutableDictionary * _registeredDrivers;
}

+ (NSString *)descriptionForCode:(ORDAResultCode)code
{
	switch (code) {
		case kORDASucessResultCode:
			return @"Success";
			
		case kORDAErrorResultCode:
			return @"Error";
		case kORDANilDriverErrorResultCode:
			return @"Error - Driver is nil";
		case kORDANoMemoryErrorResultCode:
			return @"Error - Insufficient memory";
		case kORDANilConnectionErrorResultCode:
			return @"Error - Connection is nil";
		case kORDAUnknownErrorResultCode:
			return @"Error - Unknown";
			
		case kORDAInternalErrorResultCode:
			return @"Internal Error";
		case kORDAUnimplementedAPIErrorResultCode:
			return @"Internal Error - Unimplemented API";
		case kORDAInternalAPIMismatchErrorResultCode:
			return @"Internal Error - API mismatch";
			
		case kORDAConnectionErrorResultCode:
			return @"Connection Error";
		case kORDANilURLErrorResultCode:
			return @"Connection Error - URL is nil";
		case kORDAMissingDriverErrorResultCode:
			return @"Connection Error - No driver found for scheme";
		case kORDABadURLErrorResultCode:
			return @"Connection Error - Bad URL";
			
		case kORDAStatementErrorResultCode:
			return @"Statement Error";
		case kORDANilGovernorErrorResultCode:
			return @"Statement Error - Governor is nil";
		case kORDANilStatementSQLErrorResultCode:
			return @"Statement Error - Statement SQL is nil";
		case kORDABadStatementSQLErrorResultCode:
			return @"Statement Error - Statement SQL is bad";
		case kORDABadBindIndexErrorResultCode:
			return @"Statement Error - Bind index is bad";
			
		case kORDATableErrorResultCode:
			return @"Table Error";
		case kORDANilTableNameErrorResultCode:
			return @"Table Error - Name is nil";
			
		default:
			return @"Bad result code";
	}
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
		return (id<ORDAGovernor>)[ORDAErrorResult errorWithCode:kORDANilURLErrorResultCode andProtocol:@protocol(ORDAGovernor)];
	
	id<ORDADriver> driver = _registeredDrivers[URL.scheme];
	
	if (!driver)
		return (id<ORDAGovernor>)[ORDAErrorResult errorWithCode:kORDAMissingDriverErrorResultCode andProtocol:@protocol(ORDAGovernor)];
	
	NSURL * subURL = [NSURL URLWithString:URL.resourceSpecifier];
	
	if (!subURL)
		return (id<ORDAGovernor>)[ORDAErrorResult errorWithCode:kORDABadURLErrorResultCode andProtocol:@protocol(ORDAGovernor)];
	
	return [driver governorForURL:subURL];
}

@end
