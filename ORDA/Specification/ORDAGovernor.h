//
//  ORDAGovernor.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDAResult.h"

@protocol ORDAStatement, ORDATable;

@protocol ORDAGovernor <ORDAResult>

- (id<ORDAStatement>)createStatement:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (id<ORDATable>)createTable:(NSString *)tableName;

@end
