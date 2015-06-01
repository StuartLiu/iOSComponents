//
//  LConfigureEntity.m
//
//  Created by Liu Stuart on 15/5/29.
//  Copyright (c) 2015年 Lines. All rights reserved.
//

#import "LConfigureEntity.h"

@implementation LConfigureEntity

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.params forKey:@"params"];
    [aCoder encodeObject:self.resultType forKey:@"resultType"];
    [aCoder encodeObject:self.method forKey:@"method"];
    [aCoder encodeObject:@(self.cacheSeconds) forKey:@"cacheSeconds"];
    [aCoder encodeObject:@(self.isSecure) forKey:@"isSecure"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.params = [aDecoder decodeObjectForKey:@"params"];
        self.resultType = [aDecoder decodeObjectForKey:@"resultType"];
        self.method = [aDecoder decodeObjectForKey:@"method"];
        self.cacheSeconds = [[aDecoder decodeObjectForKey:@"cacheSeconds"] integerValue];
        self.isSecure = [[aDecoder decodeObjectForKey:@"isSecure"] boolValue];
    }
    return self;
}

@end
