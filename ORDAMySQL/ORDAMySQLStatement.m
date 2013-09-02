//
//  ORDAMySQLStatement.m
//  ORDA
//
//  Created by Ethan Reesor on 8/19/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAMySQLStatement.h"

#import "ORDAMySQLErrorResult.h"
#import "ORDAMySQLGovernor.h"
#import "ORDAStatementResult.h"
#import "ORDAStatementResultImpl.h"

@implementation ORDAMySQLStatement {
	id<ORDAStatementResult> _result;
}

- (id)initWithGovernor:(id<ORDAGovernor>)governor withSQL:(NSString *)SQL
{
	if (!(self = [super initWithGovernor:governor withSQL:SQL]))
		return nil;
	
	if (self.code != kORDASucessResultCode)
		return self;
	
	if (![governor isKindOfClass:[ORDAMySQLGovernor class]])
		return (ORDAMySQLStatement *)[ORDAMySQLErrorResult errorWithCode:(ORDACode)kORDAInternalAPIMismatchErrorResultCode].retain;
	_connection = [(ORDAMySQLGovernor *)governor connection];
	
	_result = nil;
	
	_statement = mysql_stmt_init(self.connection);
	if (!self.statement)
		return (ORDAMySQLStatement *)[ORDAMySQLErrorResult errorWithCode:(ORDACode)kORDANoMemoryErrorResultCode andMySQL:self.connection].retain;
	
	NSRange semi = [SQL rangeOfString:@";"];
	int status = mysql_stmt_prepare(self.statement, [SQL cStringUsingEncoding:NSASCIIStringEncoding], semi.location == NSNotFound ? SQL.length : semi.location);
	if (status)
		return (ORDAMySQLStatement *)[ORDAMySQLErrorResult errorWithMySQL:self.connection].retain;
	
	_bindCount = mysql_stmt_param_count(self.statement);
	_bind = calloc(self.bindCount, sizeof(MySQLBindData *));
	
	if (semi.location == NSNotFound) {
		_nextStatement = nil;
		goto exit;
	}
	
	_nextStatement = [[ORDAMySQLStatement alloc] initWithGovernor:governor withSQL:[SQL substringFromIndex:semi.location+1]];
	if (!_nextStatement)
		return (ORDAMySQLStatement *)[ORDAMySQLErrorResult errorWithCode:(ORDACode)kORDAInternalErrorResultCode].retain;
	if (_nextStatement.code != kORDASucessResultCode)
		return _nextStatement;
	
exit:
	return self;
}

- (void)dealloc
{
	if (_bind) {
		[self clearBindings];
		free(_bind);
	}
	
	[_result release];
	[_nextStatement release];
	
	[super dealloc];
}

- (id<ORDAStatementResult>)result
{
	if (!_result) {
		MYSQL_BIND * parameters = calloc(self.bindCount, sizeof(MYSQL_BIND));
		for (int i = 0; i < self.bindCount; i++) {
			switch (self.bind[i]->type) {
				case kMySQLBindBlobType:
					;
					NSData * data = self.bind[i]->data;
					parameters[i].buffer_type = MYSQL_TYPE_BLOB;
					parameters[i].buffer_length = data.length;
					parameters[i].buffer = malloc(parameters[i].buffer_length);
					memcpy(parameters[i].buffer, data.bytes, data.length);
					break;
					
				case kMySQLBindDoubleType:
					parameters[i].buffer_type = MYSQL_TYPE_DOUBLE;
					parameters[i].buffer_length = sizeof(double);
					parameters[i].buffer = malloc(parameters[i].buffer_length);
					*((double *)parameters[i].buffer) = ((NSNumber *)self.bind[i]->data).doubleValue;
					
				case kMySQLBindIntegerType:
					parameters[i].buffer_type = MYSQL_TYPE_LONG;
					parameters[i].buffer_length = sizeof(int);
					parameters[i].buffer = malloc(parameters[i].buffer_length);
					*((int *)parameters[i].buffer) = ((NSNumber *)self.bind[i]->data).intValue;
					
				case kMySQLBindLongType:
					parameters[i].buffer_type = MYSQL_TYPE_LONGLONG;
					parameters[i].buffer_length = sizeof(long);
					parameters[i].buffer = malloc(parameters[i].buffer_length);
					*((long *)parameters[i].buffer) = ((NSNumber *)self.bind[i]->data).longValue;
					
				case kMySQLBindTextType:
					;
					NSString * str = self.bind[i]->data;
					parameters[i].buffer_type = MYSQL_TYPE_STRING;
					parameters[i].buffer_length = sizeof(str.length);
					parameters[i].buffer = malloc(parameters[i].buffer_length);
					memcpy(parameters[i].buffer, [str cStringUsingEncoding:NSUTF8StringEncoding], str.length);
					
				default:
					parameters[i].buffer_type = MYSQL_TYPE_NULL;
					parameters[i].buffer_length = 0;
					parameters[i].buffer = 0;
					break;
			}
		}
		mysql_stmt_execute(self.statement);
		
		for (int i = 0; i < self.bindCount; i++)
			free(parameters[i].buffer);
		free(parameters);
		
		MYSQL_RES * resmeta = mysql_stmt_result_metadata(self.statement);
		unsigned int columns = mysql_num_fields(resmeta);
		unsigned long long rows = mysql_num_rows(resmeta);
		unsigned long long lastID = mysql_insert_id(self.connection);
		unsigned long long changed = mysql_affected_rows(self.connection);
		
		MYSQL_FIELD * fields = mysql_fetch_fields(resmeta);
		MYSQL_BIND * results = calloc(columns, sizeof(MYSQL_BIND));
		NSMutableArray * columnNames = [NSMutableArray arrayWithCapacity:columns];
		for (int i = 0; i < columns; i++) {
			columnNames[i] = [NSString stringWithCString:fields[i].name encoding:NSUTF8StringEncoding];
			switch (results[i].buffer_type = fields[i].type) {
				case MYSQL_TYPE_TINY:
					results[i].buffer_length = sizeof(char);
					break;
				case MYSQL_TYPE_SHORT:
					results[i].buffer_length = sizeof(short int);
					break;
				case MYSQL_TYPE_INT24:
				case MYSQL_TYPE_LONG:
					results[i].buffer_length = sizeof(int);
					break;
				case MYSQL_TYPE_LONGLONG:
					results[i].buffer_length = sizeof(long long int);
					break;
				case MYSQL_TYPE_BIT:
					results[i].buffer_length = 8;
					break;
				case MYSQL_TYPE_FLOAT:
					results[i].buffer_length = sizeof(float);
					break;
				case MYSQL_TYPE_DOUBLE:
					results[i].buffer_length = sizeof(double);
					break;
				case MYSQL_TYPE_NEWDECIMAL:
					results[i].buffer_length = 64;
					break;
				case MYSQL_TYPE_TIME:
				case MYSQL_TYPE_DATE:
				case MYSQL_TYPE_DATETIME:
				case MYSQL_TYPE_TIMESTAMP:
					results[i].buffer_length = sizeof(MYSQL_TIME);
					break;
				case MYSQL_TYPE_STRING:
				case MYSQL_TYPE_VAR_STRING:
				case MYSQL_TYPE_TINY_BLOB:
				case MYSQL_TYPE_BLOB:
				case MYSQL_TYPE_MEDIUM_BLOB:
				case MYSQL_TYPE_LONG_BLOB:
					results[i].buffer_length = 256;
					break;
				default:
					results[i].buffer_length = 0;
					break;
			}
			results[i].buffer = malloc(results[i].buffer_length);
		}
		
		NSMutableDictionary * arrayDict = [NSMutableDictionary dictionaryWithCapacity:columns];
		for (id key in columnNames)
			arrayDict[key] = [NSMutableArray arrayWithCapacity:rows];
		
		NSMutableArray * dictArray = [NSMutableArray arrayWithCapacity:rows];
		id sharedKeySet = [NSDictionary sharedKeySetForKeys:columnNames];
		
		mysql_stmt_bind_result(self.statement, results);
		for (int i = 0; i < rows; i++) {
			NSMutableDictionary * row = [NSMutableDictionary dictionaryWithSharedKeySet:sharedKeySet];
			mysql_stmt_fetch(self.statement);
			dictArray[i] = row;
			for (int j = 0; j < columns; j++) {
				id key = columnNames[j];
				id obj = [NSNull null];
				switch (results[i].buffer_type) {
					case MYSQL_TYPE_TINY:
						obj = [NSNumber numberWithChar:*((char *)results[i].buffer)];
						break;
					case MYSQL_TYPE_SHORT:
						obj = [NSNumber numberWithShort:*((short int *)results[i].buffer)];
						break;
					case MYSQL_TYPE_INT24:
					case MYSQL_TYPE_LONG:
							obj = [NSNumber numberWithInt:*((int *)results[i].buffer)];
						break;
					case MYSQL_TYPE_LONGLONG:
						obj = [NSNumber numberWithLongLong:*((long long int *)results[i].buffer)];
						break;
					case MYSQL_TYPE_BIT:
						obj = [NSNumber numberWithLong:*((long *)results[i].buffer)];
						break;
					case MYSQL_TYPE_FLOAT:
						obj = [NSNumber numberWithFloat:*((float *)results[i].buffer)];
						break;
					case MYSQL_TYPE_DOUBLE:
						obj = [NSNumber numberWithDouble:*((double *)results[i].buffer)];
						break;
					case MYSQL_TYPE_NEWDECIMAL:
						break;
					case MYSQL_TYPE_TIME:
					case MYSQL_TYPE_DATE:
					case MYSQL_TYPE_DATETIME:
					case MYSQL_TYPE_TIMESTAMP:
						;
						MYSQL_TIME * mtime = results[i].buffer;
						NSDateComponents * ctime = [[[NSDateComponents alloc] init] autorelease];
						ctime.year = mtime->year;
						ctime.month = mtime->month;
						ctime.day = mtime->day;
						ctime.hour = mtime->hour;
						ctime.minute = mtime->minute;
						ctime.second = mtime->second;
						obj = [[NSCalendar currentCalendar] dateFromComponents:ctime];
						break;
					case MYSQL_TYPE_STRING:
					case MYSQL_TYPE_VAR_STRING:
					case MYSQL_TYPE_TINY_BLOB:
					case MYSQL_TYPE_BLOB:
					case MYSQL_TYPE_MEDIUM_BLOB:
					case MYSQL_TYPE_LONG_BLOB:
						obj = [[NSString alloc] initWithBytes:results[i].buffer length:*(results[i].length) encoding:NSUTF8StringEncoding];
					default:
						break;
				}
				row[key] = obj;
				arrayDict[key][i] = row[key];
			}
		}
		
		for (int i = 0; i < columns; i++)
			free(results[i].buffer);
		free(results);
		mysql_free_result(resmeta);
		
		_result = [ORDAStatementResultImpl statementResultWithChanged:changed andLastID:lastID andRows:(long)rows andColumns:columnNames andDictionaryOfArrays:arrayDict andArrayOfDictionaries:dictArray];
	}
	
	return _result;
}

- (id<ORDAResult>)reset
{
	if (!_result)
		return nil;
	
	[_result release];
	_result = nil;
	
	mysql_stmt_reset(self.statement);
	return (id<ORDAResult>)[ORDAMySQLErrorResult errorWithMySQLStatement:self.statement];
}

- (id<ORDAResult>)bindBlob:(NSData *)data toIndex:(int)index
{
	id<ORDAResult> result = [self bindNullToIndex:index];
	if (result.isError)
		return result;
	
	MySQLBindData * bind = self.bind[index] = malloc(sizeof(MySQLBindData));
	
	bind->type = kMySQLBindBlobType;
	bind->data = data.retain;
	
	return result;
}

- (id<ORDAResult>)bindDouble:(NSNumber *)number toIndex:(int)index
{
	id<ORDAResult> result = [self bindNullToIndex:index];
	if (result.isError)
		return result;
	
	MySQLBindData * bind = self.bind[index] = malloc(sizeof(MySQLBindData));
	
	bind->type = kMySQLBindDoubleType;
	bind->data = number.retain;
	
	return result;
}

- (id<ORDAResult>)bindInteger:(NSNumber *)number toIndex:(int)index
{
	id<ORDAResult> result = [self bindNullToIndex:index];
	if (result.isError)
		return result;
	
	MySQLBindData * bind = self.bind[index] = malloc(sizeof(MySQLBindData));
	
	bind->type = kMySQLBindIntegerType;
	bind->data = number.retain;
	
	return result;
}

- (id<ORDAResult>)bindLong:(NSNumber *)number toIndex:(int)index
{
	id<ORDAResult> result = [self bindNullToIndex:index];
	if (result.isError)
		return result;
	
	MySQLBindData * bind = self.bind[index] = malloc(sizeof(MySQLBindData));
	
	bind->type = kMySQLBindLongType;
	bind->data = number.retain;
	
	return result;
}

- (id<ORDAResult>)bindNullToIndex:(int)index
{
	if (index >= self.bindCount)
		return (id<ORDAResult>)[ORDAMySQLErrorResult errorWithCode:(ORDACode)kORDABadBindIndexErrorResultCode].retain;
	
	MySQLBindData * bind = self.bind[index];
	if (bind) {
		[bind->data release];
		free(bind);
	}
	bind = self.bind[index] = NULL;
	
	return [ORDAMySQLErrorResult errorWithCode:(ORDACode)kORDASucessResultCode];
}

- (id<ORDAResult>)bindText:(NSString *)string withEncoding:(NSStringEncoding)encoding toIndex:(int)index
{
	id<ORDAResult> result = [self bindNullToIndex:index];
	if (result.isError)
		return result;
	
	MySQLBindData * bind = self.bind[index] = malloc(sizeof(MySQLBindData));
	
	bind->type = kMySQLBindTextType;
	bind->data = string.retain;
	
	return result;
}

- (id<ORDAResult>)clearBindings
{
	id<ORDAResult> result = nil;
	for (int i = 0; i < self.bindCount && !result.isError; i++)
		result = [self bindNullToIndex:i];
	return result;
}

@end
