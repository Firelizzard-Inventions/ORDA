//
//  ORDATableImpl.h
//  ORDA
//
//  Created by Ethan Reesor on 8/24/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAResultImpl.h"

#import "ORDATable.h"

@protocol ORDAGovernor;

@interface ORDATableImpl : ORDAResultImpl <ORDATable>

@property (readonly) NSString * name;
@property (readonly) id<ORDAGovernor> governor;

+ (ORDATableImpl *)tableWithGovernor:(id<ORDAGovernor>)governor withName:(NSString *)tableName;
- (id)initWithGovernor:(id<ORDAGovernor>)governor withName:(NSString *)tableName;

@end
