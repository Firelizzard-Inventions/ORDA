//
//  ORDASQLiteConsts.h
//  ORDA
//
//  Created by Ethan Reesor on 8/13/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAResultConsts.h"

typedef enum {
	kORDASQLiteResultCodeConnectionErrorSubclass = 0x0100 | kORDAResultCodeDriverClass
} ORDASQLiteResultCodeErrorSubclass;

typedef enum {
	kORDASQLiteErrorResultCode = kORDAResultCodeDriverClass,
	kORDASQLiteUnsupportedEncodingErrorResultCode,
	
	kORDASQLiteConnectionErrorResultCode = kORDASQLiteResultCodeConnectionErrorSubclass,
	kORDASQLiteFileDoesNotExistErrorResultCode
} ORDASQLiteResultCodeError;