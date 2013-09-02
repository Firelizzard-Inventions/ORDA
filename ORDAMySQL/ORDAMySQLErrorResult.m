//
//  ORDAMySQLErrorResult.m
//  ORDA
//
//  Created by Ethan Reesor on 8/19/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAMySQLErrorResult.h"

#import "ORDAMySQLDriver.h"

@implementation ORDAMySQLErrorResult

+ (ORDADriverResult *)errorWithCode:(ORDAMySQLResultCodeError)code
{
	return [super driverWithCode:code forDriver:[ORDAMySQLDriver sharedInstance] andProtocol:nil];
}

+ (ORDAMySQLErrorResult *)errorWithCode:(ORDAMySQLResultCodeError)code andMySQL:(MYSQL *)connection
{
	return [[[self alloc] initWithCode:code andMySQL:connection] autorelease];
}

+ (ORDAMySQLErrorResult *)errorWithMySQL:(MYSQL *)connection
{
	return [self errorWithCode:kORDAMySQLErrorResultCode andMySQL:connection];
}

+ (ORDAMySQLErrorResult *)errorWithCode:(ORDAMySQLResultCodeError)code andMySQLStatement:(MYSQL_STMT *)statement
{
	return [[[self alloc] initWithCode:code andMySQLStatement:statement] autorelease];
}

+ (ORDAMySQLErrorResult *)errorWithMySQLStatement:(MYSQL_STMT *)statement
{
	return [self errorWithCode:kORDAMySQLStatementErrorResultCode andMySQLStatement:statement];
}

- (id)initWithCode:(ORDAMySQLResultCodeError)code andMySQL:(MYSQL *)connection
{
	if (!(self = [super initWithCode:code forDriver:[ORDAMySQLDriver sharedInstance] andProtocol:nil]))
		return nil;
	
	if (!connection)
		return (ORDAMySQLErrorResult *)[ORDAMySQLErrorResult errorWithCode:(ORDACode)kORDANilConnectionErrorResultCode].retain;
	
	_error_number = mysql_errno(connection);
	_error_status = [[NSString alloc] initWithCString:mysql_error(connection) encoding:NSASCIIStringEncoding];
	
	if (self.error_status.length < 1)
		return (ORDAMySQLErrorResult *)[ORDAMySQLErrorResult errorWithCode:(ORDACode)kORDASucessResultCode].retain;
	
	return self;
}

- (id)initWithCode:(ORDAMySQLResultCodeError)code andMySQLStatement:(MYSQL_STMT *)statement
{
	if (!(self = [super initWithCode:code forDriver:[ORDAMySQLDriver sharedInstance] andProtocol:nil]))
		return nil;
	
	if (!statement)
		return (ORDAMySQLErrorResult *)[ORDAMySQLErrorResult errorWithCode:kORDAMySQLNilStatementErrorResultCode].retain;
	
	_error_number = mysql_stmt_errno(statement);
	_error_status = [[NSString alloc] initWithCString:mysql_stmt_error(statement) encoding:NSASCIIStringEncoding];
	
	if (self.error_status.length < 1)
		return (ORDAMySQLErrorResult *)[ORDAMySQLErrorResult errorWithCode:(ORDACode)kORDASucessResultCode].retain;
	
	return self;
}

- (void)dealloc
{
	[_error_status release];
	
	[super dealloc];
}

@end
