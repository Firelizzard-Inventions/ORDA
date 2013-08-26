//
//  ORDAStatementResultImpl.m
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDAStatementResultImpl.h"

#import <TypeExtensions/NSObject+abstractClass.h>


@implementation ORDAStatementResultImpl

+ (ORDAStatementResultImpl *)statementResultWithChanged:(int)changed andLastID:(long long)lastID andRows:(int)rows andColumns:(NSArray *)columns andDictionaryOfArrays:(NSDictionary *)dict andArrayOfDictionaries:(NSArray *)array
{
	return [[[ORDAStatementResultImpl alloc] initWithChanged:changed andLastID:lastID andRows:rows andColumns:columns andDictionaryOfArrays:dict andArrayOfDictionaries:array] autorelease];
}

- (id)initWithChanged:(int)changed andLastID:(long long)lastID andRows:(int)rows andColumns:(NSArray *)columns andDictionaryOfArrays:(NSDictionary *)dict andArrayOfDictionaries:(NSArray *)array
{
	if (!(self = [super initWithSucessCode]))
		return nil;
	
	_changed = changed;
	_lastID = lastID;
	_dict = dict.copy;
	_array = array.copy;
	
	return self;
}

- (void)dealloc
{
	[_array release];
	[_dict release];
	
	[super dealloc];
}

- (int)rows
{
	return (int)self.array.count;
}

- (int)columns
{
	return (int)self.dict.count;
}

- (NSDictionary *)objectAtIndexedSubscript:(NSUInteger)idx
{
	return self.array[idx];
}

- (NSArray *)objectForKeyedSubscript:(id)key
{
	return self.dict[key];
}

@end