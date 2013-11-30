//
//  ORDASQLite.m
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "CocoaSQLite.h"

#import "ORDASQLiteDriver.h"

@implementation CocoaSQLite

+ (void)register
{
	[ORDASQLiteDriver class];
}

+ (NSString *)scheme
{
	return @"sqlite";
}

@end
