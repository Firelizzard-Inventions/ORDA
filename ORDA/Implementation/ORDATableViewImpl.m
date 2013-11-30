//
//  ORDATableViewImpl.m
//  ORDA
//
//  Created by Ethan Reesor on 11/29/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDATableViewImpl.h"

#import <TypeExtensions/TypeExtensions.h>

SUPPRESS(-Wprotocol)
@implementation ORDATableViewImpl {
	NSUInteger _mutationsCount;
}

- (void)reload
{
	_mutationsCount++;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id [])buffer count:(NSUInteger)len
{
	NSUInteger count = self.count,
			   selfIndex = state->state,
			   bufferIndex = 0;
	
	while (bufferIndex < len && selfIndex < count)
		buffer[bufferIndex++] = self[selfIndex++];
	
	state->state = selfIndex;
	state->itemsPtr = buffer;
	state->mutationsPtr = &_mutationsCount;
	
	return bufferIndex;
}

@end
