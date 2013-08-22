//
//  ORDASQLiteGovernorImpl.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAGovernorImpl.h"

#import <sqlite3.h>

@interface ORDASQLiteGovernor : ORDAGovernorImpl

@property (readonly) sqlite3 * connection;

- (id)initWithURL:(NSURL *)URL;

@end
