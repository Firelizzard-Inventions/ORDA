//
//  main.m
//  NotFailTest
//
//  Created by Ethan Reesor on 8/20/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>

#import "ORDAResultConsts.h"
#import "ORDAResult.h"
#import "ORDADriver.h"
#import "ORDAGovernor.h"
#import "ORDAStatement.h"
#import "ORDAStatementResult.h"

#import "ORDA.h"
#import "ORDASQLite.h"
#import "ORDAStatementImpl.h"

int main(int argc, const char * argv[])
{
	@autoreleasepool {
		[ORDASQLite register];
		
		NSString * path = [[NSBundle bundleForClass:[ORDA class]] pathForResource:@"Chinook_Sqlite" ofType:@"sqlite"];
		NSString * str = [NSString stringWithFormat:@"%@:%@", [ORDASQLite scheme], [NSURL fileURLWithPath:path]];
		NSURL * URL = [NSURL URLWithString:str];
		id<ORDAGovernor> governor = [[ORDA sharedInstance] governorForURL:URL];
		
		if (governor.isError) {
			NSLog(@"Governor error");
			return 0;
		}
		
		id<ORDAStatement> statement = [governor createStatement:@"SELECT * FROM Track LIMIT 10"];
		
		if (statement.isError) {
			NSLog(@"Statement error");
			return 0;
		}
		
		id<ORDAStatementResult> result = statement.result;
		
		if (result.isError) {
			NSLog(@"Result error");
			return 0;
		}
		
		NSLog(@"Changes: %d, Last ID: %lld, Rows: %d, columns: %d", result.changed, result.lastID, result.rows, result.columns);
//		for (int i = 0; i < result.rows; i++)
//			NSLog(@"%@", result[i]);
		
		NSLog(@"%@", [governor columnNamesForTableName:@"Track"]);
		NSLog(@"%@", [governor primaryKeyNamesForTableName:@"Track"]);
		NSLog(@"%@", [governor foreignKeyTableNamesForTableName:@"Track"]);
	}
    return 0;
}

