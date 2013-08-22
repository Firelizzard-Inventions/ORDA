//
//  ORDAStatement.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDAResult.h"

@protocol ORDAStatementResult;

@protocol ORDAStatement <ORDAResult>

- (NSString *)statementSQL;
- (id<ORDAStatementResult>)result;
- (id<ORDAResult>)reset;
- (id<ORDAStatement>)nextStatement;
- (id<NSFastEnumeration>)fastEnumerate;

- (id<ORDAResult>)bindBlob:(NSData *)data toIndex:(int)index;
- (id<ORDAResult>)bindDouble:(NSNumber *)number toIndex:(int)index;
- (id<ORDAResult>)bindInteger:(NSNumber *)number toIndex:(int)index;
- (id<ORDAResult>)bindLong:(NSNumber *)number toIndex:(int)index;
- (id<ORDAResult>)bindNullToIndex:(int)index;
- (id<ORDAResult>)bindText:(NSString *)string withEncoding:(NSStringEncoding)encoding toIndex:(int)index;

- (id<ORDAResult>)clearBindings;

@end
