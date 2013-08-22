//
//  ORDASQLiteStatement.h
//  ORDA
//
//  Created by Ethan Reesor on 8/13/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDAStatementImpl.h"

#import <sqlite3.h>

@class ORDASQLiteGovernor;

@interface ORDASQLiteStatement : ORDAStatementImpl

@property (readonly) sqlite3 * connection;
@property (readonly) sqlite3_stmt * statement;
@property (readonly) ORDASQLiteStatement * nextStatement;

- (NSObject *)columnObjectForIndex:(int)index;
- (NSData *)columnBlobForIndex:(int)index;
- (NSNumber *)columnDoubleForIndex:(int)index;
- (NSNumber *)columnIntegerForIndex:(int)index;
- (NSNumber *)columnLongForIndex:(int)index;
- (NSString *)columnTextWithEncoding:(NSStringEncoding)encoding forIndex:(int)index;

- (int)indexOfBindParameter:(NSString *)parameter;

- (id<ORDAResult>)bindBlob:(NSData *)data toParameter:(NSString *)parameter;
- (id<ORDAResult>)bindDouble:(NSNumber *)number toParameter:(NSString *)parameter;
- (id<ORDAResult>)bindInteger:(NSNumber *)number toParameter:(NSString *)parameter;
- (id<ORDAResult>)bindLong:(NSNumber *)number toParameter:(NSString *)parameter;
- (id<ORDAResult>)bindNullToParameter:(NSString *)parameter;
- (id<ORDAResult>)bindText:(NSString *)string withEncoding:(NSStringEncoding)encoding toParameter:(NSString *)parameter;

@end
