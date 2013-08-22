//
//  ORDAResult.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import <Foundation/Foundation.h>

#import "ORDAResultConsts.h"

@protocol ORDAResult <NSObject>

- (ORDAResultCode)code;
- (BOOL)isError;

@end