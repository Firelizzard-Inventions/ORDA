//
//  ORDAMySQLGovernor.h
//  ORDA
//
//  Created by Ethan Reesor on 8/19/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAGovernorImpl.h"

#import "include/mysql.h"

@interface ORDAMySQLGovernor : ORDAGovernorImpl

@property (readonly) MYSQL * connection;

- (id)initWithURL:(NSURL *)URL;

@end
