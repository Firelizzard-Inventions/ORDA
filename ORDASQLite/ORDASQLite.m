//
//  ORDASQLite.m
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDASQLite.h"

#import "ORDASQLiteDriver.h"

@implementation ORDASQLite

+ (void)register
{
	[ORDASQLiteDriver class];
}

+ (NSString *)scheme
{
	return @"sqlite";
}

@end
