//
//  ORDAStatement.h
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ORDAStatementResult;

@protocol ORDAStatement <NSObject>

- (NSString *)statementSQL;
- (id<ORDAStatementResult>)result;

@end
