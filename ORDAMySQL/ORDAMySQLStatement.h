//
//  ORDAMySQLStatement.h
//  ORDA
//
//  Created by Ethan Reesor on 8/19/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAStatementImpl.h"

#import "include/mysql.h"

@interface ORDAMySQLStatement : ORDAStatementImpl

typedef enum {
	kMySQLBindBlobType,
	kMySQLBindDoubleType,
	kMySQLBindIntegerType,
	kMySQLBindLongType,
	kMySQLBindNullType,
	kMySQLBindTextType
} MySQLBindType;

typedef struct {
	MySQLBindType type;
	id data;
} MySQLBindData;

@property (readonly) MYSQL * connection;
@property (readonly) MYSQL_STMT * statement;
@property (readonly) ORDAMySQLStatement * nextStatement;

@property (readonly) unsigned long bindCount;
@property (readonly) MySQLBindData ** bind;

@end
