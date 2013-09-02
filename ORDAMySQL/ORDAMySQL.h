//
//  ORDAMySQL.h
//  ORDA
//
//  Created by Ethan Reesor on 8/19/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * ORDAMySQL is the only outward facing component of the ORDA MySQL driver.
 */
@interface ORDAMySQL : NSObject

/**
 * Registers the ORDA MySQL driver
 */
+ (void)register;

/**
 * @returns "sqlite", the ORDA MySQL URL scheme
 */
+ (NSString *)scheme;

@end
