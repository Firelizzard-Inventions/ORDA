//
//  ORDAStatementResultImpl.m
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAStatementResultImpl.h"

#import <TypeExtensions/NSObject+abstractClass.h>


@implementation ORDAStatementResultImpl

+ (NSDictionary *)arrayDictFromDictArray:(NSArray *)array andRows:(int)rows andColumns:(NSArray *)columns
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:rows];
	for (id key in columns)
		dict[key] = [NSMutableArray arrayWithCapacity:array.count];
	
	for (int i = 0; i < array.count; i++)
		for (id key in array[i])
			dict[key][i] = array[i][key];
	
	NSMutableDictionary * temp = [NSMutableDictionary dictionaryWithCapacity:rows];
	for (id key in dict)
		temp[key] = [NSArray arrayWithArray:dict[key]];
	
	return [NSDictionary dictionaryWithDictionary:temp];
}

+ (NSArray *)dictArrayFromArrayDict:(NSDictionary *)dict andRows:(int)rows andColumns:(NSArray *)columns
{
	id sharedKeySet = [NSDictionary sharedKeySetForKeys:columns];
	NSMutableArray * array = [NSMutableArray arrayWithCapacity:rows];
	for (int i = 0; i < rows; i++)
		array[i] = [NSMutableDictionary dictionaryWithSharedKeySet:sharedKeySet];
	
	for (id key in dict)
		for (int i = 0; i < rows; i++)
			array[i][key] = dict[key][i];
	
	NSMutableArray * temp = [NSMutableArray arrayWithCapacity:rows];
	for (int i = 0; i < rows; i++)
		temp[i] = [NSDictionary dictionaryWithDictionary:array[i]];
	
	return [NSArray arrayWithArray:temp];
}

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
	
exit:
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