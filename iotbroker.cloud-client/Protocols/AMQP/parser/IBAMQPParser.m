/**
 * Mobius Software LTD
 * Copyright 2015-2017, Mobius Software LTD
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */

#import "IBAMQPParser.h"

@implementation IBAMQPParser

+ (NSInteger) next : (NSMutableData *) buffer {
   
    [buffer clearNumber];
    
    NSInteger length = [buffer readInt];

    if (length == 1095586128) {
        NSInteger protocolId = [buffer readByte];
        NSInteger versionMajor = [buffer readByte];
        NSInteger versionMinor = [buffer readByte];
        NSInteger versionRevision = [buffer readByte];
        if ((protocolId == IBAMQPProtocolId  || protocolId == IBAMQPProtocolIdTLS || protocolId == IBAMQPProtocolIdSASL) && versionMajor == 1 && versionMinor == 0 && versionRevision == 0) {
            [buffer clearNumber];
            return 8;
        } else {
            [buffer clearNumber];
            return -1;
        }
    }
    [buffer clearNumber];
    return length;
}

+ (IBAMQPHeader *) decode : (NSMutableData *) buffer {
        
    if ([[buffer readStringWithLength:4] isEqualToString:IBAMQPProtocolName]) {
        IBAMQPProtoHeader *protoHeader = [[IBAMQPProtoHeader alloc] init];
        protoHeader.protocolID = [buffer readByte];
        protoHeader.versionMajor = [buffer readByte];
        protoHeader.versionMinor = [buffer readByte];
        protoHeader.versionRevision = [buffer readByte];
        return protoHeader;
    }
    
    [buffer clearNumber];
        
    NSInteger length = [buffer readInt] & 0xffffffffL;
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
    

    if (length == 1095586128 && (doff == 3 || doff == 0) && type == 1 && chennel == 0) {
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
    
    if (type == 0) {
        header = [IBAMQPFactory amqp:buffer];
    } else if (type == 1) {
        header = [IBAMQPFactory sasl:buffer];
    } else {
        @throw [NSException exceptionWithName:[[self class] description]
                                       reason:@"Received malformed header with invalid type"
                                     userInfo:nil];
    }
    
    if (header.code.value == IBAMQPTransferHeaderCode) {
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
        return data;
    }
    
    [data appendInt:[header getLength]];
    [data appendByte:header.doff];
    [data appendByte:header.type];
    [data appendShort:header.chanel];
        
    [data appendData:[header arguments].data];
    
    if (header.code.value == IBAMQPTransferHeaderCode) {
        NSMutableArray<id<IBAMQPSection>> *sections = [NSMutableArray arrayWithArray:((IBAMQPTransfer *)header).sections.allValues];
        for (id<IBAMQPSection> section in sections) {
            [data appendData:section.value.data];
        }
    }
    
    return data;
}

@end
