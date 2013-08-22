//
//  ORDAErrorResult.h
//  ORDA
//
//  Created by Ethan Reesor on 8/20/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import <TypeExtensions/NSObject_ProtocolConformer.h>

#import "ORDAResult.h"

@interface ORDAErrorResult : NSObject_ProtocolConformer <ORDAResult>

@property (readonly) ORDAResultCode code;

+ (id<NSObject>)errorWithCode:(ORDAResultCode)code andProtocol:(Protocol *)protocol;
- (id)initWithCode:(ORDAResultCode)code andProtocol:(Protocol *)protocol;

@end
