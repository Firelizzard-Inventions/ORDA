//
//  ORDATableResultImpl.m
//  ORDA
//
//  Created by Ethan Reesor on 8/25/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDATableResultImpl.h"

@implementation ORDATableResultImpl {
	NSArray * _backing;
}

+ (ORDATableResultImpl *)tableResultWithArray:(NSArray *)array
{
	return [[[self alloc] initWithArray:array] autorelease];
}

+ (ORDATableResultImpl *)tableResultWithObject:(id)obj
{
	return [self tableResultWithArray:[NSArray arrayWithObject:obj]];
}

- (id)initWithArray:(NSArray *)array
{
	if (!(self = [super initWithSucessCode]))
		return nil;
	
	_backing = array.copy;
	
	return self;
}

- (void)dealloc
{
	[_backing release];
	
	[super dealloc];
}

- (NSUInteger)count
{
	return _backing.count;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
	return _backing[idx];
}

@end
