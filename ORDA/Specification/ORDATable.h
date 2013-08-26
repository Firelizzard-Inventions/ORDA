//
//  ORDATable.h
//  ORDA
//
//  Created by Ethan Reesor on 8/24/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ORDAResult.h"

@protocol ORDATableResult;

@protocol ORDATable <ORDAResult>

- (NSArray *)columnNames;
- (NSArray *)primaryKeyNames;
- (NSArray *)foreignKeyTableNames;

- (id<ORDATableResult>)selectWhere:(NSString *)clause;
- (id<ORDATableResult>)insertValues:(id)values;
- (id<ORDATableResult>)updateSet:(NSString *)column to:(id)value where:(NSString *)clause;

@end
