//
//  ORDASQLiteTableView.h
//  ORDA
//
//  Created by Ethan Reesor on 11/29/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDATableViewImpl.h"

@class ORDASQLiteTable;
@protocol ORDAStatementResult;

@interface ORDASQLiteTableView : ORDATableViewImpl

@property (readonly) ORDASQLiteTable * table;
@property (readonly) NSArray * keys;

+ (ORDASQLiteTableView *)viewWithTable:(ORDASQLiteTable *)table andClause:(NSString *)clause;
- (id)initWithTable:(ORDASQLiteTable *)table andClause:(NSString *)clause;

@end
