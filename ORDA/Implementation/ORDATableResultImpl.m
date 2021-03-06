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
	return [[self alloc] initWithArray:array];
}

+ (ORDATableResultImpl *)tableResultWithObject:(id)obj
{
	return [self tableResultWithArray:@[obj]];
}

- (id)initWithArray:(NSArray *)array
{
	if (!(self = [super initWithSucessCode]))
		return nil;
	
	_backing = array.copy;
	
	return self;
}


- (NSUInteger)count
{
	return _backing.count;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
	return _backing[idx];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
	return [_backing countByEnumeratingWithState:state objects:buffer count:len];
}

@end
