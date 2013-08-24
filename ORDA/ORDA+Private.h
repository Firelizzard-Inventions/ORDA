//
//  ORDA_Private.h
//  ORDA
//
//  Created by Ethan Reesor on 8/23/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDA.h"

@interface ORDA ()

/** ----------------------------------------------------------------------------
 * @name Result Code Checking
 */

/**
 * Checks a code against another code with a mask
 * @param code the code
 * @param test the code to test against
 * @param mask the mask to use
 * @return true if code matches test after masking
 * @discussion This simply checks to see if code equals test after code has been
 * masked (ANDed) with the mask.
 */
+ (BOOL)code:(ORDAResultCode)code matchesCode:(ORDACode)test withMask:(ORDAResultCodeMask)mask;

/**
 * Checks a code against a class
 * @param code the code
 * @param class the class
 * @return true if the code matches the class
 * @discussion This calls code:matchesCode:withMask:, passing class as test and
 * kORDAResultCodeClassMask as mask.
 * @see code:matchesCode:withMask:
 */
+ (BOOL)code:(ORDAResultCode)code matchesClass:(ORDAResultCodeClass)class;

/**
 * Checks a code against a subclass
 * @param code the code
 * @param subclass the subclass
 * @return true if the code matches the subclass
 * @discussion This calls code:matchesCode:withMask:, passing subclass as test and
 * kORDAResultCodeSubclassMask as mask.
 * @see code:matchesCode:withMask:
 */
+ (BOOL)code:(ORDAResultCode)code matchesSubclass:(ORDAResultCodeSubclass)subclass;

/** ----------------------------------------------------------------------------
 * @name Properties
 */

/**
 * The currently registered drivers
 * @discussion This provides a mechanism by which the currently registered
 * drivers can be retreived. I'm not sure why this exists.
 */
@property (readonly) NSArray * registeredDrivers;

@end
