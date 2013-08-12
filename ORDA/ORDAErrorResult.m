//
//  ORDAErrorResult.m
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAErrorResult.h"

@implementation ORDAErrorResult

- (id)initWithCode:(ORDAResultCode)code
{
	if ((code & kORDAResultCodeClassMask) != kORDAResultCodeErrorClass)
		return nil;
	
	if (!(self = [super initWithType:kORDAErrorResult andCode:code]))
		return nil;
	
	return self;
}

@end
