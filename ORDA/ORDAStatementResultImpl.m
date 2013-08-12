//
//  ORDAStatementResultImpl.m
//  ORDA
//
//  Created by Ethan Reesor on 8/11/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAStatementResultImpl.h"

@implementation ORDAStatementResultImpl

- (NSUInteger)count
{
	return 0;
}

- (id<ORDASelectResult>)selectResult
{
	return nil;
}

- (id<ORDAInsertResult>)insertResult
{
	return nil;
}

- (id<ORDAUpdateResult>)updateResult
{
	return nil;
}

- (id<ORDADeleteResult>)deleteResult
{
	return nil;
}

@end
