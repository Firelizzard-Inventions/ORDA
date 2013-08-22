//
//  ORDADriverErrorResult.h
//  ORDA
//
//  Created by Ethan Reesor on 8/13/13.
//  Copyright (c) 2013 Firelizzard Inventions. Some rights reserved, see license.
//

#import "ORDAErrorResult.h"

@protocol ORDADriver;

@interface ORDADriverResult : ORDAErrorResult

@property (readonly) id<ORDADriver> driver;

+ (ORDADriverResult *)driverWithCode:(ORDADriverCode)code forDriver:(id<ORDADriver>)driver andProtocol:(Protocol *)protocol;
- (id)initWithCode:(ORDADriverCode)code forDriver:(id<ORDADriver>)driver andProtocol:(Protocol *)protocol;

@end
