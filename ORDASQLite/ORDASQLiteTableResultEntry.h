//
//  ORDASQLiteTableResultEntry.h
//  ORDA
//
//  Created by Ethan Reesor on 8/25/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ORDASQLiteTableResultEntry : NSDictionary

@property (readonly) NSNumber * rowid;

+ (ORDASQLiteTableResultEntry *)tableResultEntryWithRowID:(NSNumber *)rowid andData:(NSDictionary *)data;
- (id)initWithRowID:(NSNumber *)rowid andData:(NSDictionary *)data;

@end
