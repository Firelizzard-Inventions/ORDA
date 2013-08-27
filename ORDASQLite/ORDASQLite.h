//
//  ORDASQLite.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import <Foundation/Foundation.h>

/**
 * ORDASQLite is the only outward facing component of the ORDA SQLite driver.
 */
@interface ORDASQLite : NSObject

/**
 * Registers the ORDA SQLite driver
 */
+ (void)register;

/**
 * @returns "sqlite", the ORDA SQLite URL scheme
 */
+ (NSString *)scheme;

@end
