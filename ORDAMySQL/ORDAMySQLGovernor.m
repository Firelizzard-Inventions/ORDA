//
//  ORDAMySQLGovernor.m
//  ORDA
//
//  Created by Ethan Reesor on 8/19/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAMySQLGovernor.h"

#import "ORDAMySQLErrorResult.h"
#import "ORDAMySQLStatement.h"

@implementation ORDAMySQLGovernor

- (id)initWithURL:(NSURL *)URL
{
	if (!(self = [super init]))
		return nil;
	
	if (self.code != kORDASucessResultCode)
		return self;
	
	_connection = mysql_init(NULL);
	if (!self.connection)
		return (ORDAMySQLGovernor *)[ORDAMySQLErrorResult errorWithCode:(ORDACode)kORDANoMemoryErrorResultCode].retain;
	
	NSString * host = URL.host;
	if (!host)
		return (ORDAMySQLGovernor *)[ORDAMySQLErrorResult errorWithCode:kORDAMySQLBadHostErrorResultCode].retain;
	const char * cHost = [host cStringUsingEncoding:NSASCIIStringEncoding];
	
	NSString * user = URL.user;
	if (!user)
		return (ORDAMySQLGovernor *)[ORDAMySQLErrorResult errorWithCode:kORDAMySQLBadUsernameErrorResultCode].retain;
	const char * cUser = [host cStringUsingEncoding:NSASCIIStringEncoding];
	
	NSString * pass = URL.password;
	if (!pass)
		return (ORDAMySQLGovernor *)[ORDAMySQLErrorResult errorWithCode:kORDAMySQLBadPasswordErrorResultCode].retain;
	const char * cPass = [host cStringUsingEncoding:NSASCIIStringEncoding];
	
	NSString * db = URL.path;
	if (!db)
		return (ORDAMySQLGovernor *)[ORDAMySQLErrorResult errorWithCode:kORDAMySQLBadDatabaseErrorResultCode].retain;
	const char * cDB = db.length == 0 ? NULL : [host cStringUsingEncoding:NSASCIIStringEncoding];
	
	NSNumber * port = URL.port;
	if (!port)
		return (ORDAMySQLGovernor *)[ORDAMySQLErrorResult errorWithCode:kORDAMySQLBadPortErrorResultCode].retain;
	unsigned int cPort = port.intValue;
	
	_connection = mysql_real_connect(self.connection, cHost, cUser, cPass, cDB, cPort, NULL, 0);
	if (!self.connection)
		return (ORDAMySQLGovernor *)[ORDAMySQLErrorResult errorWithCode:(ORDACode)kORDAConnectionErrorResultCode andMySQL:self.connection].retain;
	
	if (mysql_options(self.connection, MYSQL_SET_CHARSET_NAME, "utf8"))
		return (ORDAMySQLGovernor *)[ORDAMySQLErrorResult errorWithMySQL:self.connection].retain;
	
	return self;
}

- (void)dealloc
{
	if (_connection)
		mysql_close(_connection);
	
	[super dealloc];
}

- (id<ORDAStatement>)createStatement:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)
{
	va_list args;
	va_start(args, format);
	NSString * statementSQL = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
	va_end(args);
	
	return [ORDAMySQLStatement statementWithGovernor:self withSQL:statementSQL];
}

- (id<ORDATable>)createTable:(NSString *)tableName
{
	return (id<ORDATable>)[ORDAMySQLErrorResult errorWithCode:(ORDACode)kORDAUnimplementedAPIErrorResultCode];
}

@end
