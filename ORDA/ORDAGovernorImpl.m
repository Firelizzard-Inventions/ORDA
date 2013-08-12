//
//  ORDAGovernor.m
//  ORDA
//
//  Created by Ethan Reesor on 8/7/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAGovernorImpl.h"

@implementation ORDAGovernorImpl

- (id)init
{
	if (!(self = [super initWithType:kORDAResult andCode:kORDASucessResultCode]))
		return nil;
	
	return self;
}

@end
