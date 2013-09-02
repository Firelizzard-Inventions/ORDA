//
//  ORDAMySQLErrorResult.h
//  ORDA
//
//  Created by Ethan Reesor on 8/19/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDADriverResult.h"

#import "include/mysql.h"
#import "ORDAMySQLConsts.h"

@interface ORDAMySQLErrorResult : ORDADriverResult

@property (readonly) NSInteger error_number;
@property (readonly) NSString * error_status;

+ (ORDADriverResult *)errorWithCode:(ORDAMySQLResultCodeError)code;
+ (ORDAMySQLErrorResult *)errorWithCode:(ORDAMySQLResultCodeError)code andMySQL:(MYSQL *)connection;
+ (ORDAMySQLErrorResult *)errorWithMySQL:(MYSQL *)connection;
+ (ORDAMySQLErrorResult *)errorWithCode:(ORDAMySQLResultCodeError)code andMySQLStatement:(MYSQL_STMT *)statement;
+ (ORDAMySQLErrorResult *)errorWithMySQLStatement:(MYSQL_STMT *)statement;
- (id)initWithCode:(ORDAMySQLResultCodeError)code andMySQL:(MYSQL *)connection;
- (id)initWithCode:(ORDAMySQLResultCodeError)code andMySQLStatement:(MYSQL_STMT *)statement;

@end
