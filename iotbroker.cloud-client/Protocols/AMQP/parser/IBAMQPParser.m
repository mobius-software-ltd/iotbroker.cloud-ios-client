//
//  IBAMQPParser.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPParser.h"
#import "IBAMQPTransfer.h"
#import "IBAMQPFactory.h"
#import "IBAMQPProtoHeader.h"
#import "IBAMQPPing.h"

@implementation IBAMQPParser

//+ (NSInteger) next : (NSMutableData *) buffer {
    
//}

+ (IBAMQPHeader *) decode : (NSMutableData *) buffer {
    
    long length = [buffer readInt] & 0xffffffff;
    int doff = [buffer readByte] & 0xff;
    int type = [buffer readByte] & 0xff;
    int chennel = [buffer readShort] & 0xffff;

    if (length == 8 && doff == 2 && (type == 0 || type == 1) && chennel == 0) {
        if ((buffer.length - [buffer getByteNumber]) == 0) {
            return [[IBAMQPPing alloc] init];
        } else {
            @throw [NSException exceptionWithName:[[self class] description]
                                           reason:@"Received malformed ping-header with invalid length"
                                         userInfo:nil];
        }
    }
    
    if (length == 1095586128 && doff == 3 && (type == 0 || type == 1) && chennel == 0) {
        if ((buffer.length - [buffer getByteNumber]) == 0) {
            return [[IBAMQPPing alloc] init];
        } else {
            @throw [NSException exceptionWithName:[[self class] description]
                                           reason:@"Received malformed protocol-header with invalid length"
                                         userInfo:nil];
        }
    }
    
    if (length != (buffer.length - [buffer getByteNumber]) + 8) {
        @throw [NSException exceptionWithName:[[self class] description]
                                       reason:@"Received malformed header with invalid length"
                                     userInfo:nil];
    }
    
    IBAMQPHeader *header = nil;
    
    if (header.type == IBAMQPTransferHeaderCode) {
        while ((buffer.length - [buffer getByteNumber]) > 0) {
            [((IBAMQPTransfer *)header) addSections:@[[IBAMQPFactory section:buffer]]];
        }
    }
    
    return header;
}

+ (NSMutableData *) encode : (IBAMQPHeader *) header {

    NSMutableData *data = [NSMutableData data];
    
    if ([header isKindOfClass:[IBAMQPProtoHeader class]]) {
        [data appendData:[IBAMQPProtocolName dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendByte:((IBAMQPProtoHeader *)header).protocolID];
        [data appendByte:((IBAMQPProtoHeader *)header).versionMajor];
        [data appendByte:((IBAMQPProtoHeader *)header).versionMinor];
        [data appendByte:((IBAMQPProtoHeader *)header).versionRevision];
        return data;
    }
    
    if ([header isKindOfClass:[IBAMQPPing class]]) {
        [data appendInt:8];
        [data appendByte:header.doff];
        [data appendByte:header.type];
        [data appendShort:header.chanel];
    }
    
    int length = 8;
    
    IBAMQPTLVList *arguments = [header arguments];
    length += arguments.length;
    
    NSMutableArray<id<IBAMQPSection>> *sections = nil;
    
    if (header.type == IBAMQPTransferHeaderCode) {
        sections = [NSMutableArray arrayWithArray:((IBAMQPTransfer *)header).sections.allValues];
        for (id<IBAMQPSection> section in sections) {
            length += section.value.length;
        }
    }
    
    [data appendInt:length];
    [data appendByte:header.doff];
    [data appendByte:header.type];
    [data appendShort:header.chanel];
    [data appendData:arguments.data];
    
    if (sections != nil) {
        for (id<IBAMQPSection> section in sections) {
            [data appendData:section.value.data];
        }
    }
    
    return data;
}

@end
