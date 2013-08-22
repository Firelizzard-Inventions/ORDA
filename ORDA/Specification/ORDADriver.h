//
//  ORDADriver.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import <Foundation/Foundation.h>

@protocol ORDAGovernor;

@protocol ORDADriver <NSObject>

- (NSString *)scheme;
- (id<ORDAGovernor>)governorForURL:(NSURL *)url;

@end
