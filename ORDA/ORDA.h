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

/**
 * The goal of the Objective Relational Database Abstraction is to provide a
 * simple interface that abstracts interaction with RDBMSes from their
 * respective APIs by creating a system whose externally visible details are
 * agnostic of the particular system being used. Because of the idiosyncracy of
 * the various systems that this API is attempting to cohere, the full power of
 * those APIs will be unavaliable without breaking the abstraction. This system
 * is intended to be similar to JDBC in that the user supplies a URL with some
 * prefix (the scheme) and the manager (this class) determines the correct ORDA
 * driver to handle said scheme and passes the URL to it, generating a governor.
 * @see ORDAResult
 */
@interface ORDA : NSObject_Singleton

/** ----------------------------------------------------------------------------
 * @name Registering Drivers
 */

/**
 * Registers a driver
 * @param driver the driver
 * @discussion This associates the specified driver with it's scheme in the ORDA
 * system so that it can be later used to generate a governor from a URL.
 * @see governorForURL:
 */
- (void)registerDriver:(id<ORDADriver>)driver;

/** ----------------------------------------------------------------------------
 * @name Retreiving Governors
 */

/**
 * Generates a governor for a URL
 * @param URL the URL
 * @return the governor or an error result
 * @discussion This retreives the driver associated with the URL's scheme and
 * uses said driver to generate a governor (which is returned). The possible
 * non-success result codes are: kORDANilURILErrorResultCode if the URL is nil,
 * kORDAMissingDriverErrorResultCode if no driver is associated with the scheme,
 * kORDABadURLErrorResultCode if the URL-sans-scheme cannot be parsed as a URL.
 * It is important to know that the driver may return a non-success result.
 * @see ORDADriver
 */
- (id<ORDAGovernor>)governorForURL:(NSURL *)URL;

@end