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

#import "IBCoParser.h"

@implementation IBCoParser

+ (id<IBMessage>) decode : (NSMutableData *) buffer {

    IBCoMessage *message = [[IBCoMessage alloc] init];
    
    [buffer clearNumber];

    Byte firstByte = [buffer readByte];
    Byte version = firstByte >> 6;
    if (version != message.version) {
        @throw [NSException exceptionWithName:@"CoAP parser" reason:[NSString stringWithFormat:@"Invalid version: %hhu", version] userInfo:nil];
    }
    
    message.type = (firstByte >> 4) & 0x3;
    
    Byte tokenLength = firstByte & 0xF;
    if (tokenLength > 8) {
        @throw [NSException exceptionWithName:@"CoAP parser" reason:[NSString stringWithFormat:@"Invalid token length: %hhu", tokenLength] userInfo:nil];
    }
    
    int codeByte = [buffer readByte];
    int codeValue = (codeByte >> 5) * 100;
    codeValue += codeByte & 0x1F;
    message.code = codeValue;
    message.messageID = [buffer readShort];
    
    if (tokenLength > 0) {
        NSData *data = [buffer dataWithLength:tokenLength];
        NSString *number = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        message.token = [number integerValue];
    }
    
    int number = 0;
    
    while ([buffer getByteNumber] < [buffer length]) {
        Byte nextByte = [buffer readByte];
        if (nextByte == 0xFF) {
            break;
        }
        int delta = (nextByte >> 4) & 15;
        
        if (delta == 13) {
            delta = [buffer readByte] + 13;
        } else if (delta == 14) {
            delta = [buffer readShort] + 269;
        } else if (delta > 14) {
            @throw [NSException exceptionWithName:@"CoAP parser" reason:[NSString stringWithFormat:@"Invalid option delta value: %d", delta] userInfo:nil];
        }
        
        number += delta;

        int optionLength = nextByte & 15;
        if (optionLength == 13) {
            optionLength = [buffer readByte] + 13;
        } else if (optionLength == 14) {
            optionLength = [buffer readShort] + 269;
        } else if (optionLength > 14) {
            @throw [NSException exceptionWithName:@"CoAP parser" reason:[NSString stringWithFormat:@"Invalid option delta value: %d", optionLength] userInfo:nil];
        }
        
        NSMutableData *optionValue = [NSMutableData data];
        if (optionLength > 0) {
            optionValue = [buffer dataWithLength:optionLength];
        }
        
        IBCoOption *option = [[IBCoOption alloc] initWithNumber:number length:optionLength value:optionValue];
        [message addOption:option];
    }
    
    if ([buffer getByteNumber] < [buffer length]) {
        int size = (int)(buffer.length - [buffer getByteNumber]);
        message.payload = [buffer dataWithLength:size];
    }

    return message;
}

+ (NSMutableData *) encode : (id<IBMessage>) mess {
    
    IBCoMessage *message = (IBCoMessage *)mess;
    NSMutableData *buffer = [NSMutableData data];

    Byte firstByte = 0;
    
    firstByte += message.version << 6;
    firstByte += message.type << 4;

    if (message.token != -1) {
        firstByte += [@(message.token) stringValue].length;
    }
    
    [buffer appendByte:firstByte];
    
    int codeMsb = (message.code / 100);
    int codeLsb = (message.code % 100);
    int codeByte = ((codeMsb << 5) + codeLsb);
    
    [buffer appendByte:codeByte];
    [buffer appendShort:message.messageID];
    
    if (message.token != -1) {
        NSString *token = [[NSNumber numberWithLong:message.token] stringValue];
        [buffer appendData:[token dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    int previousNumber = 0;

    for (IBCoOption *option in [message options]) {
        int delta = option.number - previousNumber;
        int nextByte = 0;
        
        int extendedDelta = -1;
        if (delta  < 13) {
            nextByte += delta << 4;
        } else {
            extendedDelta = delta;
            if (delta < 0xFF) {
                nextByte = 13 << 4;
            } else {
                nextByte = 14 << 4;
            }
        }
        
        int extendedLength = -1;
        if (option.length < 13) {
            nextByte += option.length;
        } else {
            extendedLength = option.length;
            if (option.length < 0xFF) {
                nextByte += 13;
            } else {
                nextByte += 14;
            }
        }
        
        [buffer appendByte:nextByte];
        
        if (extendedDelta != -1) {
            if (extendedDelta < 0xFF) {
                [buffer appendByte:extendedDelta - 13];
            } else {
                [buffer appendShort:extendedDelta - 269];
            }
        }
        
        if (extendedLength != -1) {
            if (extendedLength < 0xFF) {
                [buffer appendByte:extendedLength - 13];
            } else {
                [buffer appendShort:extendedDelta - 269];
            }
        }
        
        [buffer appendData:option.value];
        previousNumber = option.number;
    }
    
    [buffer appendByte:0xFF];
    
    if (message.payload.length > 0) {
        [buffer appendData:message.payload];
    }
    
    return buffer;
}

@end
