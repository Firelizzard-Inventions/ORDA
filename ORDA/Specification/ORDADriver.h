//
//  ORDADriver.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ORDAGovernor;

@protocol ORDADriver <NSObject>

- (NSString *)scheme;
- (id<ORDAGovernor>)governorForURL:(NSURL *)url;

@end
