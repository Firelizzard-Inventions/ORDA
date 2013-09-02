//
//  ORDAMySQLTable.h
//  ORDA
//
//  Created by Ethan Reesor on 9/1/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDATableImpl.h"

@interface ORDAMySQLTable : ORDATableImpl

- (NSString *)whereClauseForKeys:(NSArray *)keys;

@end
