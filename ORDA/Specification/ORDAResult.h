//
//  ORDAResult.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ORDAResultConsts.h"

@protocol ORDAResult <NSObject>

- (ORDAResultCode)code;
- (BOOL)isError;

@end