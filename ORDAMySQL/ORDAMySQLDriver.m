//
//  ORDAMySQLDriver.m
//  ORDA
//
//  Created by Ethan Reesor on 8/19/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAMySQLDriver.h"

#import "ORDA.h"
#import "ORDAMySQL.h"
#import "ORDAMySQLGovernor.h"

@implementation ORDAMySQLDriver

+ (void)initialize
{
	[[ORDA sharedInstance] registerDriver:[self sharedInstance]];
}

- (id)init {
	static ORDAMySQLDriver * _shared = nil;
	
	@synchronized([ORDAMySQLDriver class]) {
		if (_shared == nil) {
			if (!(_shared = self = [super init]))
				return nil;
		}
	}
	
	return _shared;
}

- (NSString *)scheme
{
	return [ORDAMySQL scheme];
}

- (id<ORDAGovernor>)governorForURL:(NSURL *)url
{
	return [[[ORDAMySQLGovernor alloc] initWithURL:url] autorelease];
}

@end
