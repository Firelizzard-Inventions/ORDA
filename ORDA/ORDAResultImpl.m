//
//  ORDAResultImpl.m
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAResultImpl.h"

@implementation ORDAResultImpl

- (id)initWithType:(ORDAResultType)type andCode:(ORDAResultCode)code
{
	if (!(self = [super init]))
		return nil;
	
	_type = type;
	_code = code;
	
	return self;
}

@end
