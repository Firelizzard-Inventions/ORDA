//
//  ORDAMySQLConsts.h
//  ORDA
//
//  Created by Ethan Reesor on 8/19/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAResultConsts.h"

typedef enum {
	kORDAMySQLResultCodeConnectionErrorSubclass = 0x0100 | kORDAResultCodeDriverClass,
	kORDAMySQLResultCodeStatementErrorSubclass = 0x0200 | kORDAResultCodeDriverClass,
	kORDAMySQLResultCodeTableErrorSubclass = 0x0300 | kORDAResultCodeDriverClass
} ORDAMySQLResultCodeErrorSubclass;

typedef enum {
	kORDAMySQLErrorResultCode = kORDAResultCodeDriverClass,
	
	kORDAMySQLConnectionErrorResultCode = kORDAMySQLResultCodeConnectionErrorSubclass,
	kORDAMySQLBadHostErrorResultCode,
	kORDAMySQLBadUsernameErrorResultCode,
	kORDAMySQLBadPasswordErrorResultCode,
	kORDAMySQLBadDatabaseErrorResultCode,
	kORDAMySQLBadPortErrorResultCode,
	
	kORDAMySQLStatementErrorResultCode = kORDAMySQLResultCodeStatementErrorSubclass,
	kORDAMySQLNilStatementErrorResultCode,
	
	kORDAMySQLTableErrorResultCode = kORDAMySQLResultCodeTableErrorSubclass,
	kORDAMySQLWrongNumberOfKeysErrorResultCode
} ORDAMySQLResultCodeError;
