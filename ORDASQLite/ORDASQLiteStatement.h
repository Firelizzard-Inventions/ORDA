//
//  ORDASQLiteStatement.h
//  ORDA
//
//  Created by Ethan Reesor on 8/13/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDAStatementImpl.h"

#import <sqlite3.h>

@interface ORDASQLiteStatement : ORDAStatementImpl

//@property (readonly) sqlite3 * connection;
@property (readonly) sqlite3_stmt * statement;
@property (readonly) ORDASQLiteStatement * nextStatement;

@end
