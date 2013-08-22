//
//  ORDA.h
//  ORDA
//
//  Created by Ethan Reesor on 8/7/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import <TypeExtensions/NSObject_Singleton.h>

#import "ORDAResultConsts.h"
#import "ORDAResult.h"
#import "ORDADriver.h"
#import "ORDAGovernor.h"
#import "ORDAStatement.h"
#import "ORDAStatementResult.h"

@interface ORDA : NSObject_Singleton

+ (BOOL)code:(ORDAResultCode)code matchesCode:(ORDACode)test withMask:(ORDAResultCodeMask)mask;
+ (BOOL)code:(ORDAResultCode)code matchesClass:(ORDAResultCodeClass)class;
+ (BOOL)code:(ORDAResultCode)code matchesSubclass:(ORDAResultCodeSubclass)subclass;


@property (readonly) NSArray * registeredDrivers;

- (void)registerDriver:(id<ORDADriver>)driver;

- (id<ORDAGovernor>)governorForURL:(NSURL *)URL;

@end