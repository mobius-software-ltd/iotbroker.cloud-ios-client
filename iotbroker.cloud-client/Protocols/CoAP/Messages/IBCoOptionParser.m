//
//  IBCoOptionParser.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 05.10.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//

#import "IBCoOptionParser.h"
#import "IBMutableData.h"

@implementation IBCoOptionParser

+ (NSData *)encode:(IBCoAPOptionDefinitions)type object:(NSObject *)object {
    
    NSData *data = [NSData data];

    switch (type) {
        case IBUriPortOption:
        case IBContentFormatOption:
        case IBAcceptOption:
            if ([object isKindOfClass:[NSNumber class]]) {
                NSMutableData *dt = [[NSMutableData alloc] init];
                [dt appendByte:0x00];
                [dt appendByte:[((NSNumber *)object) intValue]];
                data = dt;
            }
            break;
        case IBMaxAgeOption:
        case IBSize1Option:
        case IBObserveOption:
            if ([object isKindOfClass:[NSNumber class]]) {
                NSMutableData *dt = [[NSMutableData alloc] init];
                [dt appendInt:[((NSNumber *)object) intValue]];
                data = dt;
            }
            break;
        case IBNodeId:
        case IBIfMatchOption:
        case IBUriHostOption:
        case IBETagOption:
        case IBUriPathOption:
        case IBLocationPathOption:
        case IBUriQueryOption:
        case IBLocationQueryOption:
        case IBProxySchemeOption:
        case IBProxyUriOption:
            if ([object isKindOfClass:[NSString class]]) {
                data = [((NSString *)object) dataUsingEncoding:NSUTF8StringEncoding];
            }
            break;
        default:
            break;
    }
    
    return data;
}

+ (NSObject *)decode:(IBCoAPOptionDefinitions)type data:(NSData *)data {
    
    NSObject *object = nil;
    NSMutableData *buffer = [NSMutableData dataWithData:data];
    
    switch (type) {
        case IBUriPortOption:
        case IBContentFormatOption:
        case IBAcceptOption:
            object = @([buffer readShort]);
            break;
        case IBMaxAgeOption:
        case IBSize1Option:
        case IBObserveOption:
            object = @([buffer readInt]);
            break;
        case IBNodeId:
        case IBIfMatchOption:
        case IBUriHostOption:
        case IBETagOption:
        case IBUriPathOption:
        case IBLocationPathOption:
        case IBUriQueryOption:
        case IBLocationQueryOption:
        case IBProxySchemeOption:
        case IBProxyUriOption:
            object = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            break;
        default:
            break;
    }
    
    return object;
}

@end
