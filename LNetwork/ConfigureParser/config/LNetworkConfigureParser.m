//
//  LNetworkConfigureParser.m
//
//  Created by Lines on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LNetworkConfigureParser.h"
#import "TBXML.h"
#import "LConfigureEntity.h"
#import "LLogging.h"

@implementation LNetworkConfigureParser

+ (NSDictionary *)parse:(NSString *)fileName {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSString *xml = nil;
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [resourcePath stringByAppendingPathComponent:fileName];
    @try {
        xml = [[NSString alloc] initWithContentsOfFile:filePath
                                              encoding:NSUTF8StringEncoding
                                                 error:nil];
    }
    @catch (NSException *e) {
        LogTrace(@"Exception: %@\n", e.name);
        LogTrace(@"Exception: %@\n", e.reason);
    }

    if (nil == xml)
        return nil;
    
    // parse the file
    TBXML *tbXML = [TBXML newTBXMLWithXMLString:xml error:nil];
    TBXMLElement *entity = [TBXML childElementNamed:@"entity" parentElement:tbXML.rootXMLElement];
    while (nil != entity) {
        NSString *key = [TBXML valueOfAttributeNamed:@"id" forElement:entity];
        if (key == nil)
            continue;
        LConfigureEntity *value = [LConfigureEntity new];
        TBXMLElement * element = [TBXML childElementNamed:@"url" parentElement:entity];
        value.url = [TBXML textForElement:element];
        element = [TBXML childElementNamed:@"method" parentElement:entity];
        value.method = [TBXML textForElement:element];
        
        NSString *str = nil;
        element = [TBXML childElementNamed:@"params" parentElement:entity];
        if (nil != element) {
            str = [TBXML textForElement:element];
            value.params = [str componentsSeparatedByString:@","];
        }
        
        element = [TBXML childElementNamed:@"resultType" parentElement:entity];
        value.resultType = [TBXML textForElement:element];
        
        element = [TBXML childElementNamed:@"cacheTime" parentElement:entity];
        if (nil != element) {
            str = [TBXML textForElement:element];
            value.cacheSeconds = [str intValue];
        }
        else {
            value.cacheSeconds = 0;
        }
        
        element = [TBXML childElementNamed:@"secure" parentElement:entity];
        if (nil != element) {
            str = [TBXML textForElement:element];
            value.isSecure = [str intValue];
        }
        else {
            value.isSecure = NO;
        }
        
        if (value.url.length < 3 || value.resultType.length == 0) {
            NSLog(@"Error to parse element: %@", key);
        }
        // add the value to dictionary
        if ([dic objectForKey:key]) {
            NSLog(@"Error: duplicate key: %@", key);
        }
        [dic setObject:value forKey:key];
        entity = [TBXML nextSiblingNamed:@"entity" searchFromElement:entity];
    }
    // end of parse file
    
    return dic;
}

@end
