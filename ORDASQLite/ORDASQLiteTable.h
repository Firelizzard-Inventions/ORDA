//
//  ORDASQLiteTable.h
//  ORDA
//
//  Created by Ethan Reesor on 8/24/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDATableImpl.h"

@interface ORDASQLiteTable : ORDATableImpl

- (void)updateDidOccur:(int)update toRowID:(NSNumber *)rowid;

@end
