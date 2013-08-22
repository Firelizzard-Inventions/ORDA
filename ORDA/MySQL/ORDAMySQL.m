//
//  ORDAMySQL.m
//  ORDA
//
//  Created by Ethan Reesor on 8/19/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAMySQL.h"

#import "ORDA.h"
#import "ORDAMySQLDriver.h"

@implementation ORDAMySQL

+ (void)register
{
	[ORDAMySQLDriver class];
}

+ (NSString *)scheme
{
	return @"mysql";
}

@end
