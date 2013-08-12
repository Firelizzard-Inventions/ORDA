//
//  ORDADriver.m
//  ORDA
//
//  Created by Ethan Reesor on 8/7/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDASingletonDriverImpl.h"

#import <TypeExtensions/NSObject+abstractClass.h>
#import "ORDA.h"
#import "ORDAErrorResult.h"

@implementation ORDASingletonDriverImpl

+ (void)initialize
{
	[[ORDA sharedInstance] registerDriver:[self sharedInstance]];
}

- (NSString *)scheme
{
	[ORDASingletonDriverImpl _subclassImplementationExceptionFromMethod:_cmd isClassMethod:NO];
	
	return nil;
}

- (id<ORDAGovernor>)governorForURL:(NSURL *)url
{
	[ORDASingletonDriverImpl _subclassImplementationExceptionFromMethod:_cmd isClassMethod:NO];
	
	return (id<ORDAGovernor>)[[ORDAErrorResult alloc] initWithCode:kORDAErrorResultCode];
}

@end
