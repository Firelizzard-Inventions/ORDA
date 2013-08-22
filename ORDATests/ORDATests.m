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

@implementation ORDATests {
	id<ORDAGovernor> governor;
}

- (void)setUp
{
    [super setUp];
    
	[ORDASQLite register];
	
	NSString * path = [[NSBundle bundleForClass:[ORDA class]] pathForResource:@"Chinook_Sqlite" ofType:@"sqlite"];
	NSString * str = [NSString stringWithFormat:@"%@:%@", [ORDASQLite scheme], [NSURL fileURLWithPath:path]];
	NSURL * URL = [NSURL URLWithString:str];
	
	governor = [[ORDA sharedInstance] governorForURL:URL].retain;
	if (governor.isError)
		STFail(@"Governor error");
}

- (void)tearDown
{
	[governor release];
	
    [super tearDown];
}

- (void)testSelect
{
	id<ORDAStatement> statement = [governor createStatement:@"SELECT * FROM Track LIMIT 10"];
	if (statement.isError)
		STFail(@"Statement error");
	
	id<ORDAStatementResult> result = statement.result;
	if (result.isError)
		STFail(@"Result error");
	
	NSLog(@"Changes: %d, Last ID: %lld, Rows: %d, columns: %d", result.changed, result.lastID, result.rows, result.columns);
	for (int i = 0; i < result.rows; i++)
		NSLog(@"%@", result[i]);
}

- (void)testMetadata
{
	NSLog(@"%@", [governor columnNamesForTableName:@"Track"]);
	NSLog(@"%@", [governor primaryKeyNamesForTableName:@"Track"]);
	NSLog(@"%@", [governor foreignKeyTableNamesForTableName:@"Track"]);
}

@end
