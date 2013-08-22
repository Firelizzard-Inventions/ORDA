//
//  ORDASQLiteErrorResult.h
//  ORDA
//
//  Created by Ethan Reesor on 8/13/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDADriverResult.h"

#import "ORDASQLiteConsts.h"

@interface ORDASQLiteErrorResult : ORDADriverResult

@property (readonly) int status;

+ (ORDADriverResult *)errorWithCode:(ORDASQLiteResultCodeError)code;
+ (ORDASQLiteErrorResult *)errorWithCode:(ORDASQLiteResultCodeError)code andSQLiteErrorCode:(int)code;
+ (ORDASQLiteErrorResult *)errorWithSQLiteErrorCode:(int)status;
- (id)initWithCode:(ORDASQLiteResultCodeError)code andSQLiteErrorCode:(int)status;

@end
