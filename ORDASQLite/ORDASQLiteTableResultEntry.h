//
//  ORDASQLiteTableResultEntry.h
//  ORDA
//
//  Created by Ethan Reesor on 8/25/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ORDATable;

@interface ORDASQLiteTableResultEntry : NSDictionary

@property (readonly) NSNumber * rowid;
@property (readonly) id<ORDATable> table;

+ (ORDASQLiteTableResultEntry *)tableResultEntryWithRowID:(NSNumber *)rowid andData:(NSDictionary *)data forTable:(id<ORDATable>)table;
- (id)initWithRowID:(NSNumber *)rowid andData:(NSDictionary *)data forTable:(id<ORDATable>)table;

- (void)update;

@end
