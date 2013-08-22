//
//  ORDAGovernor.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAResult.h"

@protocol ORDAStatement;

@protocol ORDAGovernor <ORDAResult>

- (id<ORDAStatement>)createStatement:(NSString *)statementSQL;

@end
