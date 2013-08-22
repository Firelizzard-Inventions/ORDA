//
//  ORDAStatementResult.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAResult.h"

@protocol ORDAStatementResult <ORDAResult>

- (int)changed;
- (int)rows;
- (int)columns;
- (long long)lastID;

- (NSDictionary *)objectAtIndexedSubscript:(NSUInteger)idx;
- (NSArray *)objectForKeyedSubscript:(id)key;

@end
