//
//  ORDATests.m
//  ORDATests
//
//  Created by Ethan Reesor on 8/7/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDATests.h"

#import "ORDA.h"
#import "ORDASQLite.h"
#import "ORDAGovernor.h"
#import "ORDAStatement.h"

@implementation ORDATests

- (void)setUp
{
    [super setUp];
    
	[ORDASQLite register];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testExample
{
//	NSString * URL = [[ORDASQLite scheme] stringByAppendingString:[NSURL fileURLWithPath:@"Chinook_Sqlite.sqlite"]];
//	id<ORDAGovernor> governor = [[ORDA sharedInstance] governorForURL:[NSURL URLWithString:URL]];
//	
//	if (!((id<ORDAResult>)governor).isSuccess)
//		STFail(@"Governor error");
//	
//	id<ORDAStatement> statement = [governor createStatement:@"SELECT * FROM sqlite_master WHERE type='table'"];
//	
//	if (!((id<ORDAResult>)statement).isSuccess)
//		STFail(@"Statement error");
//	
//	id<ORDAStatementResult> result = statement.result;
//	
//	if (!((id<ORDAResult>)result).isSuccess)
//		STFail(@"Result error");
//	
//	NSLog(@"Rows: %d, columns: %d, row 0: %@", [result rows], [result columns], result[0]);
}

@end
