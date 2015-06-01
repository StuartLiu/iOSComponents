//
//  main.m
//  NetworkConfigureParser
//
//  Created by Liu Stuart on 15/5/29.
//  Copyright (c) 2015年 Liu Stuart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdarg.h>
#import "LNetworkConfigureParser.h"
#import "LConfigureEntity.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        if (argc != 3) {
            printf("Usage: %s input_xml_file output_binary_file\n", argv[0]);
            return 1;
        }
        
        NSString *configureFile = [NSString stringWithUTF8String:argv[1]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:configureFile]) {
            printf("input xml file: %s, does NOT existed\n", argv[1]);
            return 2;
        }
        NSDictionary *configureDict = [LNetworkConfigureParser parse:configureFile];
        if (nil == configureDict) {
            printf("error with parse original\n");
            return 3;
        }
        
        printf("Parse XML file ok!\n");
        
        NSString *outputFile = [NSString stringWithUTF8String:argv[2]];
//        outputFile = [NSString stringWithFormat:@"./%@", outputFile];
        NSLog(@"output file: %@", outputFile);
        if (![[NSFileManager defaultManager] fileExistsAtPath:outputFile]) {
            [[NSFileManager defaultManager] createFileAtPath:outputFile contents:nil attributes:nil];
        }
        
//        NSMutableData *data = [[NSMutableData alloc] init];
//        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] init];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:configureDict];
        BOOL result = [data writeToFile:outputFile atomically:YES];
        if (!result) {
            printf("Write to result file FAILED!\n");
            return 4;
        }
        
        data = [NSData dataWithContentsOfFile:outputFile];
//        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:outputFile];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
        NSArray *keys = [configureDict allKeys];
        
        printf("start checking...\n");
        BOOL error = NO;
        for (NSString *key in keys) {
            LConfigureEntity *nEntity = [dic objectForKey:key];
            LConfigureEntity *entity = [configureDict objectForKey:key];
            if (!nEntity) {
                NSLog(@"Error to find: %@", key);
                error = YES;
            }
            if ([nEntity.url compare:entity.url] != NSOrderedSame ||
                [nEntity.resultType compare:entity.resultType] != NSOrderedSame ||
                [nEntity.method compare:entity.method] != NSOrderedSame ||
                nEntity.isSecure != entity.isSecure) {
                NSLog(@"Error: entity is NOT same with key: %@", key);
            }
            [dic removeObjectForKey:key];
        }
        
        if (dic.count != 0) {
            printf("Error: encoded dict is bigger than original!\n");
            error = YES;
        }
        
        if (!error) {
            printf("Everything is good!\nEnjoy!\n");
        }
    }
    return 0;
}
