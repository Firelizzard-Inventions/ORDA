//
//  ORDATable.h
//  ORDA
//
//  Created by Ethan Reesor on 8/24/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ORDAResult.h"

@protocol ORDATableResult;

/**
 * The ORDATable protocol specifies methods that can be used to manage and
 * retrieve results from a database table. Each table maintains a dictionary of
 * result row objects (those returned by -[ORDATableResult
 * objectAtIndexedSubscript:]) indexed by ID (for example, rowid in the SQLite
 * implementation) such that, for any given ID, the same pointer will always be
 * returned. This dictionary is an instance of
 * NSMutableDictionary_NonRetaining_Zeroing - thus, when there are no other
 * references to the row object besides the dictionary's, the object is removed
 * from the dictionary and deallocated. Each row object is syncrhonized with the
 * database such that changing the database changes the object and vice versa.
 */
@protocol ORDATable <ORDAResult>

/**
 * @return the associated table's name
 */
- (NSString *)name;

/**
 * @return the associated table's field names
 */
- (NSArray *)columnNames;

/**
 * @return the associated table's primary key's names
 */
- (NSArray *)primaryKeyNames;

/**
 * @return the associated table's foreign key's names
 */
- (NSArray *)foreignKeyTableNames;

/**
 * Selects from the table
 * @param format the format string for the where clause
 * @param ... the format string arguments
 * @return the selected rows
 * @discussion This method runs 'SELECT * FROM <tableName> WHERE <whereClause>'
 * on the table and returns the resulting rows.
 * @see +[NSString stringWithFormat:]
 */
- (id<ORDATableResult>)selectWhere:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

/**
 * Inserts values into the table
 * @param values an object containing the values
 * @return the inserted row
 * @discussion This method performs 'INSERT INTO <tableName> VALUES (<values>)'
 * and then returns the result of 'SELECT * FROM <tableName> WHERE {primary key}
 * = <lastID>'. The values are retrieved using -[NSObject valueForKey:].
 * @warning There is currently no way to insert only some columns.
 */
- (id<ORDATableResult>)insertValues:(id)values;

/**
 * Updates a row in the table
 * @param column the field to update
 * @param value the value to set the field to
 * @param format the format string for the where clause
 * @param ... the format string arguments
 * @return the updated rows
 * @discussion This method runs 'UPDATE <tableName> SET <column> = <value> WHERE
 * <whereClause>' and then returns the result of 'SELECT * FROM <tableName>
 * WHERE <whereClause>'.
 */
- (id<ORDATableResult>)updateSet:(NSString *)column to:(id)value where:(NSString *)format, ... NS_FORMAT_FUNCTION(1,4);

@end
