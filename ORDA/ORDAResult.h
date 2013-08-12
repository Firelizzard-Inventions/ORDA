//
//  ORDAResult.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	kORDAResultCodeClassMask = 0xF000,
	kORDAResultCodeSubclassMask = 0x0F00,
	kORDAResultCodeCodeMask = 0x00FF
} ORDAResultCodeMask;

typedef enum {
	kORDAResultCodeSucessClass = 0x0000,
	kORDAResultCodeErrorClass = 0x1000
} ORDAResultCodeClass;

typedef enum {
	kORDAResultCodeConnectionErrorSubclass = 0x0100 | kORDAResultCodeErrorClass
} ORDAResultCodeErrorSubclass;

typedef enum {
	kORDASucessResultCode = kORDAResultCodeSucessClass,
	
	kORDAErrorResultCode = kORDAResultCodeErrorClass,
	
	kORDAConnectionErrorResultCode = kORDAResultCodeConnectionErrorSubclass,
	kORDANilURLErrorResultCode,
	kORDAMissingDriverErrorResultCode,
	kORDABadURLErrorResultCode
	
} ORDAResultCode;


typedef enum {
	kORDAErrorResult = -1,
	kORDAResult,
	kORDASelectResult,
	kORDAInsertResult,
	kORDAUpdateResult,
	kORDADeleteResult
} ORDAResultType;

@protocol ORDAResult <NSObject>

- (ORDAResultType)type;
- (ORDAResultCode)code;

@end