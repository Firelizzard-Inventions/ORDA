//
//  ORDAStatementImpl.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAStatement.h"

@protocol ORDAGovernor;

@interface ORDAStatementImpl : NSObject <ORDAStatement>

@property (readonly) NSString * statementSQL;

- (id)initWithGovernor:(id<ORDAGovernor>)governor withSQL:(NSString *)SQL;

@end
