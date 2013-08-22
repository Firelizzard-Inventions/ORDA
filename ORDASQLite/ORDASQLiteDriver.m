//
//  ORDASQLiteDriver.m
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDASQLiteDriver.h"

#import "ORDA.h"
#import "ORDASQLite.h"
#import "ORDASQLiteGovernor.h"

@implementation ORDASQLiteDriver

+ (void)initialize
{
	[[ORDA sharedInstance] registerDriver:[self sharedInstance]];
}

- (id)init {
	static ORDASQLiteDriver * _shared = nil;
	
	@synchronized([ORDASQLiteDriver class]) {
		if (_shared == nil) {
			if (!(_shared = self = [super init]))
				return nil;
		}
	}
	
	return _shared;
}

- (NSString *)scheme
{
	return [ORDASQLite scheme];
}

- (id<ORDAGovernor>)governorForURL:(NSURL *)url
{
	return [[[ORDASQLiteGovernor alloc] initWithURL:url] autorelease];
}

@end
