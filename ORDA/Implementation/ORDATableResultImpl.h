//
//  ORDATableResultImpl.h
//  ORDA
//
//  Created by Ethan Reesor on 8/25/13.
//  Copyright (c) 2013 Firelizzard Inventions. All rights reserved.
//

#import "ORDAResultImpl.h"

#import "ORDATableResult.h"

@interface ORDATableResultImpl : ORDAResultImpl <ORDATableResult>

+ (ORDATableResultImpl *)tableResultWithArray:(NSArray *)array;
+ (ORDATableResultImpl *)tableResultWithObject:(id)obj;
- (id)initWithArray:(NSArray *)array;

@end
