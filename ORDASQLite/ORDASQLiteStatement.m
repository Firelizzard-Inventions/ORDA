//
//  ORDASQLiteStatement.m
//  ORDA
//
//  Created by Ethan Reesor on 8/13/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDASQLiteStatement.h"

#import "ORDASQLiteGovernor.h"
#import "ORDASQLiteErrorResult.h"
#import "ORDAStatementResultImpl.h"
#import <TypeExtensions/NSString+orNull.h>

@implementation ORDASQLiteStatement {
	id<ORDAStatementResult> _result;
}

- (id)initWithGovernor:(id<ORDAGovernor>)governor withSQL:(NSString *)SQL
{
	if (!(self = [super initWithGovernor:governor withSQL:SQL]))
		return nil;
	
	if (self.code != kORDASucessResultCode)
		return self;
	
	if (![governor isKindOfClass:[ORDASQLiteGovernor class]])
		return (ORDASQLiteStatement *)[ORDASQLiteErrorResult errorWithCode:kORDAInternalAPIMismatchErrorResultCode].retain;
	ORDASQLiteGovernor * sqlite_gov = (ORDASQLiteGovernor *)governor;
	
	_result = nil;
	
	char * rest;
	int status = sqlite3_prepare_v2(sqlite_gov.connection, [SQL cStringUsingEncoding:NSASCIIStringEncoding], (int)SQL.length, &_statement, (const char **) &rest);
	if (status != SQLITE_OK)
		return (ORDASQLiteStatement *)[ORDASQLiteErrorResult errorWithCode:(ORDACode)kORDABadStatementSQLErrorResultCode andSQLiteErrorCode:status].retain;
	
	[self reset];
	
	if (!rest[0]) {
		_nextStatement = nil;
		goto exit;
	}
	
	_nextStatement = [[ORDASQLiteStatement alloc] initWithGovernor:governor withSQL:[NSString stringWithCString:rest encoding:NSASCIIStringEncoding]];
	if (!_nextStatement)
		return (ORDASQLiteStatement *)[ORDASQLiteErrorResult errorWithCode:(ORDACode)kORDAInternalErrorResultCode].retain;
	if (_nextStatement.isError)
		return _nextStatement;
	
exit:
	return self;
}

- (void)dealloc
{
	if (_statement) sqlite3_finalize(_statement);
	[_result release];
	[_nextStatement release];
	
	[super dealloc];
}

- (id<ORDAStatementResult>)result
{
	if (!_result) {
		int status = sqlite3_step(self.statement);
		if (!(status == SQLITE_DONE || status == SQLITE_ROW))
			goto done;
		
		int rows = -1;
		int columns = sqlite3_column_count(self.statement);
		NSMutableArray * colarr = [NSMutableArray arrayWithCapacity:columns];
		for (int i = 0; i < columns; i++)
			colarr[i] = [NSString stringWithCString:sqlite3_column_name(self.statement, i) encoding:NSUTF8StringEncoding];
		
		NSMutableDictionary * arrayDict = [NSMutableDictionary dictionaryWithCapacity:columns];
		for (id key in colarr)
			arrayDict[key] = [NSMutableArray array];
		
		NSMutableArray * dictArray = [NSMutableArray array];
		id sharedKeySet = [NSDictionary sharedKeySetForKeys:colarr];
		
		do {
			NSMutableDictionary * row = [NSMutableDictionary dictionaryWithSharedKeySet:sharedKeySet];
			[dictArray addObject:row];
			for (int i = 0; i < columns; i++) {
				id key = colarr[i];
				id obj = [self columnObjectForIndex:i];
				
				row[key] = obj;
				[arrayDict[key] addObject:obj];
			}
		} while ((status = sqlite3_step(self.statement)) == SQLITE_ROW);
		rows = (int)dictArray.count;
		
	done:
		if (status == SQLITE_DONE)
			return _result = [ORDAStatementResultImpl statementResultWithChanged:-1 andLastID:-1 andRows:rows andColumns:colarr andDictionaryOfArrays:arrayDict andArrayOfDictionaries:dictArray].retain;
		else
			return _result = (id<ORDAStatementResult>)[ORDASQLiteErrorResult errorWithSQLiteErrorCode:status].retain;
	}
	
	return _result;
}

- (id<ORDAResult>)reset
{
	if (!_result)
		return nil;
	
	[_result release];
	_result = nil;
	
	return [ORDASQLiteErrorResult errorWithSQLiteErrorCode:sqlite3_reset(self.statement)];
}

- (NSObject *)columnObjectForIndex:(int)index
{
	switch (sqlite3_column_type(self.statement, index)) {
		case SQLITE_BLOB: return [self columnBlobForIndex:index];
		case SQLITE_FLOAT: return [self columnDoubleForIndex:index];
		case SQLITE_INTEGER: return [self columnLongForIndex:index];
		case SQLITE_TEXT: return [self columnTextWithEncoding:NSUTF8StringEncoding forIndex:index];
		default: return [NSNull null];
	}
}

- (NSData *)columnBlobForIndex:(int)index
{
	return [NSData dataWithBytes:sqlite3_column_blob(self.statement, index) length:sqlite3_column_bytes(self.statement, index)];
}

- (NSNumber *)columnDoubleForIndex:(int)index
{
	return @(sqlite3_column_double(self.statement, index));
}

- (NSNumber *)columnIntegerForIndex:(int)index
{
	return @(sqlite3_column_int(self.statement, index));
}

- (NSNumber *)columnLongForIndex:(int)index
{
	return @(sqlite3_column_int64(self.statement, index));
}

- (NSString *)columnTextWithEncoding:(NSStringEncoding)encoding forIndex:(int)index
{
	if (encoding == NSASCIIStringEncoding || encoding == NSUTF8StringEncoding) {
		return [NSString stringWithCStringOrNil:(const char *)sqlite3_column_text(self.statement, index) encoding:encoding];
	} else if (encoding == NSUTF16StringEncoding) {
		return [NSString stringWithCStringOrNil:(const char *)sqlite3_column_text16(self.statement, index) encoding:encoding];
	} else {
		return nil;
	}
}

- (int)indexOfBindParameter:(NSString *)parameter
{
	return sqlite3_bind_parameter_index(self.statement, [parameter cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (id<ORDAResult>)bindBlob:(NSData *)data toIndex:(int)index
{
	return [ORDASQLiteErrorResult errorWithSQLiteErrorCode:sqlite3_bind_blob(self.statement, index, [data bytes], (int)[data length], SQLITE_STATIC)];
}

- (id<ORDAResult>)bindDouble:(NSNumber *)number toIndex:(int)index
{
	return [ORDASQLiteErrorResult errorWithSQLiteErrorCode:sqlite3_bind_double(self.statement, index, number.doubleValue)];
}

- (id<ORDAResult>)bindInteger:(NSNumber *)number toIndex:(int)index
{
	return [ORDASQLiteErrorResult errorWithSQLiteErrorCode:sqlite3_bind_int(self.statement, index, number.intValue)];
}

- (id<ORDAResult>)bindLong:(NSNumber *)number toIndex:(int)index
{
	return [ORDASQLiteErrorResult errorWithSQLiteErrorCode:sqlite3_bind_int64(self.statement, index, number.longValue)];
}

- (id<ORDAResult>)bindNullToIndex:(int)index
{
	return [ORDASQLiteErrorResult errorWithSQLiteErrorCode:sqlite3_bind_null(self.statement, index)];
}

- (id<ORDAResult>)bindText:(NSString *)string withEncoding:(NSStringEncoding)encoding toIndex:(int)index
{
	if (encoding == NSASCIIStringEncoding || encoding == NSUTF8StringEncoding) {
		return [ORDASQLiteErrorResult errorWithSQLiteErrorCode:sqlite3_bind_text(self.statement, index, [string cStringUsingEncoding:encoding], (int)[string length], SQLITE_STATIC)];
	} else if (encoding == NSUTF16StringEncoding) {
		return [ORDASQLiteErrorResult errorWithSQLiteErrorCode:sqlite3_bind_text16(self.statement, index, [string cStringUsingEncoding:encoding], (int)[string length], SQLITE_STATIC)];
	} else {
		return [ORDASQLiteErrorResult errorWithCode:kORDASQLiteUnsupportedEncodingErrorResultCode];
	}
}

- (id<ORDAResult>)bindBlob:(NSData *)data toParameter:(NSString *)parameter
{
	return [self bindBlob:data toIndex:[self indexOfBindParameter:parameter]];
}

- (id<ORDAResult>)bindDouble:(NSNumber *)number toParameter:(NSString *)parameter
{
	return [self bindDouble:number toIndex:[self indexOfBindParameter:parameter]];
}

- (id<ORDAResult>)bindInteger:(NSNumber *)number toParameter:(NSString *)parameter
{
	return [self bindInteger:number toIndex:[self indexOfBindParameter:parameter]];
}

- (id<ORDAResult>)bindLong:(NSNumber *)number toParameter:(NSString *)parameter
{
	return [self bindLong:number toIndex:[self indexOfBindParameter:parameter]];
}

- (id<ORDAResult>)bindNullToParameter:(NSString *)parameter
{
	return [self bindNullToIndex:[self indexOfBindParameter:parameter]];
}

- (id<ORDAResult>)bindText:(NSString *)string withEncoding:(NSStringEncoding)encoding toParameter:(NSString *)parameter
{
	return [self bindText:string withEncoding:encoding toIndex:[self indexOfBindParameter:parameter]];
}

- (id<ORDAResult>)clearBindings
{
	return [ORDASQLiteErrorResult errorWithSQLiteErrorCode:sqlite3_clear_bindings(self.statement)];
}

@end