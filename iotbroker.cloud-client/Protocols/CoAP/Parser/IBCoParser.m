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

static int const IB13OptionFaildConstant = 13;
static int const IB14OptionFaildConstant = 14;
static int const IB15OptionFaildConstant = 15;

@implementation IBCoParser

+ (id<IBMessage>) decode : (NSMutableData *) buffer {

    IBCoMessage *message = [[IBCoMessage alloc] init];
    
    [buffer clearNumber];
    
    Byte zeroByte = [buffer readByte];
    
    Byte version = (zeroByte >> 6) & 0x3;
    
    NSLog(@" %i", version);
    
    if (version != message.version) {
        return nil;
    }
    
    message.type = (zeroByte >> 4) & 0x3;
    Byte tokenLength = (zeroByte >> 0) & 0xF;
    message.isTokenExist = (tokenLength == 0) ? false : true;
    message.code = [buffer readByte];
    
    message.messageID = [buffer numberWithLength:2];
    
    if (message.isTokenExist == true) {
        message.token = [buffer numberWithLength:tokenLength]; 
    }
    
    NSInteger previousOptionDelta = 0;
    
    NSLog(@"_%zd", message.code);
    NSLog(@"%zd", message.token);
    NSLog(@"%zd", message.type);
    NSLog(@"%zd", message.messageID);
    NSLog(@"%@_", message.payload);
    
    while ([buffer getByteNumber] < [buffer length]) {
        Byte optionByte = [buffer readByte];
        Byte optionDelta = (optionByte >> 4) & 0xF;
        Byte optionLength = optionByte & 0xF;
        
        NSLog(@"Option Delta = %zd", optionDelta);
        NSLog(@"Option Length = %zd", optionLength);
        
        if (optionDelta == IB15OptionFaildConstant) {
            if (optionLength != IB15OptionFaildConstant) {
                return nil;
            }
            break;
        }
        
        NSInteger extendedDelta = 0;
        Byte optionIndexOffset = 1;
        
        if (optionDelta == IB13OptionFaildConstant) {
            optionIndexOffset += 1;
        } else if (optionDelta == IB14OptionFaildConstant) {
            optionIndexOffset += 2;
        }
        
        if ([buffer getByteNumber] + optionIndexOffset <= [buffer length]) {
            extendedDelta = [buffer numberWithLength:optionIndexOffset - 1];
        } else {
            return nil;
        }
        
        NSInteger optionLengthExtendedOffsetIndex = optionIndexOffset;
        if (optionLength == IB13OptionFaildConstant) {
            optionIndexOffset += 1;
        } else if (optionLength == IB14OptionFaildConstant) {
            optionIndexOffset += 2;
        } else if (optionLength == IB15OptionFaildConstant) {
            return nil;
        }
        optionLength += [buffer numberWithLength:optionIndexOffset - optionLengthExtendedOffsetIndex];
        
        if ([buffer getByteNumber] + optionIndexOffset + optionLength > [buffer length]) {
            return nil;
        }
        
        NSInteger newOptionNumber = optionDelta + extendedDelta + previousOptionDelta;
        
        NSString *optionValue = [buffer readStringWithLength:optionLength];
        
        [message addOption:newOptionNumber withValue:optionValue];
        
        previousOptionDelta += optionDelta + extendedDelta;
        
    }
    
    if ([buffer getByteNumber] < [buffer length]) {
        NSInteger length = [buffer length] - [buffer getByteNumber];
        message.payload = [buffer readStringWithLength:length];
        NSLog(@"STRING = %@", message.payload);
    }
    return message;
}

+ (NSMutableData *) encode : (id<IBMessage>) mess {
    
    IBCoMessage *message = (IBCoMessage *)mess;

    NSMutableString *final = [[NSMutableString alloc] init];
    NSString *tokenAsString = [self hexStringFromInt:(int)message.token];
    
    Byte zeroByte = 0;
    
    zeroByte |= (01 << 6);
    zeroByte |= (message.type << 4);
    zeroByte |= tokenAsString.length / 2;
    
    [final appendFormat:@"%02X", zeroByte];
    [final appendFormat:@"%02lX", message.code];
    [final appendFormat:@"%04lX", message.messageID];
    [final appendFormat:@"%@", tokenAsString];

    NSArray *sortedArray = [message.optionDictionary allKeys];
    
    uint previousDelta = 0;
    
    for (NSString *key in sortedArray) {
        NSMutableArray *valueArray = [message.optionDictionary valueForKey:key];
        
        for (uint i = 0; i < [valueArray count]; i++) {
            uint delta = [key intValue] - previousDelta;
            NSString *valueForKey;
            
            if ([key intValue] == IBETagOption || [key intValue] == IBIfMatchOption) {
                valueForKey = [valueArray objectAtIndex:i];
            }
            else if ([key intValue] == IBBlock2Option || [key intValue] == IBUriPortOption  || [key intValue] == IBContentFormatOption  ||
                     [key intValue] == IBMaxAgeOption || [key intValue] == IBAcceptOption   || [key intValue] == IBSize1Option          ||
                     [key intValue] == IBSize2Option)   {
                valueForKey = [self hexStringFromInt:[[valueArray objectAtIndex:i] intValue]];
            }
            else {
                valueForKey = [self hexStringFromString:[valueArray objectAtIndex:i]];
            }
            
            int length = (int)([valueForKey length] / 2);
            
            NSString *extendedDelta = [NSString string];
            NSString *extendedLength = [NSString string];
            
            if (delta >= 269) {
                [final appendString:[NSString stringWithFormat:@"%01X", IB14OptionFaildConstant]];
                extendedDelta = [NSString stringWithFormat:@"%04X", delta - 269];
            } else if (delta >= 13) {
                [final appendString:[NSString stringWithFormat:@"%01X", IB13OptionFaildConstant]];
                extendedDelta = [NSString stringWithFormat:@"%02X", delta - IB13OptionFaildConstant];
            } else {
                [final appendString:[NSString stringWithFormat:@"%01X", delta]];
            }
            
            if (length >= 269) {
                [final appendString:[NSString stringWithFormat:@"%01X", IB14OptionFaildConstant]];
                extendedLength = [NSString stringWithFormat:@"%04X", length - 269];
            } else if (length >= IB13OptionFaildConstant) {
                [final appendString:[NSString stringWithFormat:@"%01X", IB13OptionFaildConstant]];
                extendedLength = [NSString stringWithFormat:@"%02X", length - IB13OptionFaildConstant];
            } else {
                [final appendString:[NSString stringWithFormat:@"%01X", length]];
            }
            
            [final appendString:extendedDelta];
            [final appendString:extendedLength];
            [final appendString:valueForKey];
            
            previousDelta += delta;
        }
    }
    
    if ([message.payload length] > 0) {
        if ([self payloadDecodeForMessage:message]) {
            [final appendString:[NSString stringWithFormat:@"%02X%@", 255, [self hexStringFromString:message.payload]]];
        } else {
            [final appendString:[NSString stringWithFormat:@"%02X%@", 255, message.payload]];
        }
    }
    return [self getHexDataFromString:final];
}

#pragma mark - Private methods -

+ (NSString *) hexStringFromInt : (int) value {
    NSString *string;
    if (value == 0) {
        string = [NSString string];
    }
    else if (value < 255) {
        string = [NSString stringWithFormat:@"%02X", value];
    }
    else if (value <= 65535) {
        string = [NSString stringWithFormat:@"%04X", value];
    }
    else if (value <= 16777215) {
        string = [NSString stringWithFormat:@"%06X", value];
    }
    else {
        string = [NSString stringWithFormat:@"%08X", value];
    }
    return string;
}

+ (BOOL)payloadDecodeForMessage:(id<IBMessage>)mess {
    
    IBCoMessage *message = (IBCoMessage *)mess;
    
    if (![[message optionDictionary] valueForKey:[@(IBContentFormatOption) stringValue]]) {
        return true;
    }
    else if ([[message optionDictionary] valueForKey:[@(IBContentFormatOption) stringValue]]) {
        NSMutableArray *values = [[message optionDictionary] valueForKey:[@(IBContentFormatOption) stringValue]];
        if ([[values objectAtIndex:0] intValue] == IBPlainContentFormat || [[values objectAtIndex:0] intValue] == IBLinkContentFormat
            || [[values objectAtIndex:0] intValue] == IBXMLContentFormat || [[values objectAtIndex:0] intValue] == IBJSONContentFormat) {
            return true;
        }
    }
    return false;
}

+ (NSMutableData *)getHexDataFromString:(NSString *)string {
    NSMutableData *commandData= [[NSMutableData alloc] init];
    unsigned char byteRepresentation;
    char byte_chars[3] = {'\0','\0','\0'};
    
    for (int i = 0; i < (string.length / 2); i++) {
        byte_chars[0] = [string characterAtIndex:i * 2];
        byte_chars[1] = [string characterAtIndex:i * 2 + 1];
        byteRepresentation = strtol(byte_chars, NULL, 16);
        [commandData appendBytes:&byteRepresentation length:1];
    }
    
    return commandData;
}

+ (NSString *)hexStringFromString:(NSString *) string {
    return [self stringFromDataWithHex:[NSData dataWithBytes:[string cStringUsingEncoding:NSUTF8StringEncoding] length:strlen([string cStringUsingEncoding:NSUTF8StringEncoding])]];
}

+ (NSString *)stringFromDataWithHex:(NSData *)data{
    NSString *result = [[data description] stringByReplacingOccurrencesOfString:@" " withString:@""];
    result = [result substringWithRange:NSMakeRange(1, [result length] - 2)];
    
    return result;
}

@end
