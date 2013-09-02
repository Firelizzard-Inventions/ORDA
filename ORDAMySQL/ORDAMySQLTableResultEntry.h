//
//  ORDAMySQLTableResultEntry.h
//  ORDA
//
//  Created by Ethan Reesor on 9/2/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ORDATable;

@interface ORDAMySQLTableResultEntry : NSMutableDictionary

@property (readonly) id<ORDATable> table;

+ (ORDAMySQLTableResultEntry *)tableResultEntryWithData:(NSDictionary *)data forTable:(id<ORDATable>)table;
- (id)initWithData:(NSDictionary *)data forTable:(id<ORDATable>)table;

- (void)update;

@end
