//
//  ORDASQLiteGovernorImpl.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDAGovernorImpl.h"

#import <sqlite3.h>

/**
 * ORDASQLiteGovernor is the ORDA SQLite implementation of ORDAGovernor.
 */
@interface ORDASQLiteGovernor : ORDAGovernorImpl

@property (readonly) sqlite3 * connection;

- (id)initWithURL:(NSURL *)URL;

@end
