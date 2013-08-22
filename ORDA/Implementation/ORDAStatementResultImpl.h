//
//  ORDAStatementResultImpl.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDAResultImpl.h"

#import "ORDAStatementResult.h"

@interface ORDAStatementResultImpl : ORDAResultImpl <ORDAStatementResult>

@property (readonly) int changed;
@property (readonly) long long lastID;
@property (readonly) NSDictionary * dict;
@property (readonly) NSArray * array;

+ (NSDictionary *)arrayDictFromDictArray:(NSArray *)array andRows:(int)rows andColumns:(NSArray *)columns;
+ (NSArray *)dictArrayFromArrayDict:(NSDictionary *)dict andRows:(int)rows andColumns:(NSArray *)columns;

+ (ORDAStatementResultImpl *)statementResultWithChanged:(int)changed andLastID:(long long)lastID andRows:(int)rows andColumns:(NSArray *)columns andDictionaryOfArrays:(NSDictionary *)dict andArrayOfDictionaries:(NSArray *)array;
- (id)initWithChanged:(int)changed andLastID:(long long)lastID andRows:(int)rows andColumns:(NSArray *)columns andDictionaryOfArrays:(NSDictionary *)dict andArrayOfDictionaries:(NSArray *)array;

@end
