//
//  ORDATableResult.h
//  ORDA
//
//  Created by Ethan Reesor on 8/24/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ORDAResult.h"

@protocol ORDATableResult <ORDAResult>

- (NSUInteger)count;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;

@end
