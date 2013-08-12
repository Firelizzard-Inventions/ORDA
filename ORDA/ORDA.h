//
//  ORDA.h
//  ORDA
//
//  Created by Ethan Reesor on 8/7/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import <TypeExtensions/NSObject_Singleton.h>

@protocol ORDADriver, ORDAGovernor;

@interface ORDA : NSObject_Singleton

@property (readonly) NSArray * registeredDrivers;

- (void)registerDriver:(id<ORDADriver>)driver;

- (id<ORDAGovernor>)governorForURL:(NSURL *)URL;

@end