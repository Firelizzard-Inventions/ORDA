//
//  ORDAStatementResult.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAResult.h"

@protocol ORDASelectResult, ORDAInsertResult, ORDAUpdateResult, ORDADeleteResult;

@protocol ORDAStatementResult <ORDAResult>

- (NSUInteger)count;

- (id<ORDASelectResult>)selectResult;
- (id<ORDAInsertResult>)insertResult;
- (id<ORDAUpdateResult>)updateResult;
- (id<ORDADeleteResult>)deleteResult;

@end
