//
//  ORDAErrorResult.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAResultImpl.h"

@interface ORDAErrorResult : ORDAResultImpl

- (id)initWithCode:(ORDAResultCode)code;

@end
