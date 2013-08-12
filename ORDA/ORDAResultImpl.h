//
//  ORDAResultImpl.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAResult.h"

@interface ORDAResultImpl : NSObject <ORDAResult>

@property (readonly) ORDAResultType type;
@property (readonly) ORDAResultCode code;

- (id)initWithType:(ORDAResultType)type andCode:(ORDAResultCode)code;

@end
