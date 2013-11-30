//
//  ORDASQLiteConsts.h
//  ORDA
//
//  Created by Ethan Reesor on 8/13/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import <ORDA/ORDAResultConsts.h>

typedef enum {
	kORDASQLiteResultCodeConnectionErrorSubclass = 0x0100 | kORDAResultCodeDriverClass
} ORDASQLiteResultCodeErrorSubclass;

typedef enum {
	kORDASQLiteErrorResultCode = kORDAResultCodeDriverClass,
	kORDASQLiteUnsupportedEncodingErrorResultCode,
	
	kORDASQLiteConnectionErrorResultCode = kORDASQLiteResultCodeConnectionErrorSubclass,
	kORDASQLiteFileDoesNotExistErrorResultCode
} ORDASQLiteResultCodeError;