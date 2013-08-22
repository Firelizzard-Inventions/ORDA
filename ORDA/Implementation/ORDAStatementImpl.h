//
//  ORDAStatementImpl.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAStatement.h"
#import "ORDAResultImpl.h"

@protocol ORDAGovernor;

@interface ORDAStatementImpl : ORDAResultImpl <ORDAStatement, NSFastEnumeration>

@property (readonly) NSString * statementSQL;
@property (readonly) id<ORDAGovernor> governor;

+ (ORDAStatementImpl *)statementWithGovernor:(id<ORDAGovernor>)governor withSQL:(NSString *)SQL;
- (id)initWithGovernor:(id<ORDAGovernor>)governor withSQL:(NSString *)SQL;

@end