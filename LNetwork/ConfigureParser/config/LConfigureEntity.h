//
//  LConfigureEntity.h
//
//  Created by Liu Stuart on 15/5/29.
//  Copyright (c) 2015年 Lines. All rights reserved.
//

#import <Foundation/Foundation.h>

// a structure used for network configuration xml file
// each LConfigureEntity stands for an entry in configure file, that's xml file is an dictionary with each value = LConfigureEntity
@interface LConfigureEntity : NSObject <NSCoding>

/// url string, the param will be "%@", for convenience in "get", no "%@" in "post"
@property (nonatomic, strong) NSString *url;
/// string array, each string stand for a param name in "post", or only an occupition in "get"
@property (nonatomic, strong) NSArray *params;
/// result's class name
@property (nonatomic, strong) NSString *resultType;
/// @"get" or @"post", in lowwer case
@property (nonatomic, strong) NSString *method;
/// how long the data should be cachec, unit: seconds
@property (nonatomic, assign) NSUInteger cacheSeconds;
/// YES, using https connection, NO, using http
@property (nonatomic, assign) BOOL isSecure;

@end
