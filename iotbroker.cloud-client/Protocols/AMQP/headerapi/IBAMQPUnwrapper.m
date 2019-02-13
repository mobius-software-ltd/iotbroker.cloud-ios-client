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

#import "IBAMQPUnwrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVArray.h"
#import "IBAMQPTLVMap.h"
#import "IBAMQPTLVNull.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPTLVVariable.h"

@implementation IBAMQPUnwrapper

+ (short) unwrapUByte : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPUByteType) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    Byte *bytes = (Byte *)[tlv.value bytes];
    return (short)(bytes[0] & 0xff);
}

+ (Byte) unwrapByte : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPByteType) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    Byte *bytes = (Byte *)[tlv.value bytes];
    return bytes[0];
}

+ (int) unwrapUShort : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPUShortType) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    return ([tlv.value readShort] & 0xffff);
}

+ (short) unwrapShort : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPShortType) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    return [tlv.value readShort];
}

+ (long) unwrapUInt : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPUIntType && tlv.type != IBAMQPSmallUIntType && tlv.type != IBAMQPUInt0Type) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    if (tlv.value.length == 0) {
        return 0;
    }
    if (tlv.value.length == 1) {
        Byte *bytes = (Byte *)[tlv.value bytes];
        return (bytes[0] & 0xff);
    }
    return ([tlv.value readInt] & 0xffffffff);
}

+ (int) unwrapInt : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPIntType && tlv.type != IBAMQPSmallIntType) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    if (tlv.value.length == 0) {
        return 0;
    }
    if (tlv.value.length == 1) {
        Byte *bytes = (Byte *)[tlv.value bytes];
        return bytes[0];
    }
    return [tlv.value readInt];
}

+ (unsigned long) unwrapULong : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPULongType && tlv.type != IBAMQPSmallULongType && tlv.type != IBAMQPULong0Type) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    if (tlv.value.length == 0) {
        return 0;
    }
    if (tlv.value.length == 1) {
        Byte *bytes = (Byte *)[tlv.value bytes];
        return bytes[0] & 0xff;
    }
    return [tlv.value readLong];
}

+ (long) unwrapLong : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPLongType && tlv.type != IBAMQPSmallLongType) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    if (tlv.value.length == 0) {
        return 0;
    }
    if (tlv.value.length == 1) {
        Byte *bytes = (Byte *)[tlv.value bytes];
        return (long)bytes[0];
    }
    return [tlv.value readLong];
}

+ (BOOL) unwrapBOOL : (IBTLVAMQP *) tlv {

    if (tlv.type == IBAMQPBooleanType) {
        Byte *bytes = (Byte *)[tlv.value bytes];
        Byte byte = bytes[0];
        if (bytes == 0) {
            return false;
        } else if (byte == 1) {
            return true;
        } else {
            @throw [NSException exceptionWithName:[[self class] description] reason:@"Unknown BOOL type" userInfo:nil];
        }
    } else if (tlv.type == IBAMQPBooleanTrueType) {
        return true;
    } else if (tlv.type == IBAMQPBooleanFalseType) {
        return false;
    }
    
    @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    return false;
}

+ (double) unwrapDouble : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPDoubleType) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    return [tlv.value readDouble];
}

+ (float) unwrapFloat : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPFloatType) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    return [tlv.value readFloat];
}

+ (NSDate *) unwrapTimestamp : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPTimestampType) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    NSTimeInterval interval = [tlv.value readDouble];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
}

+ (IBAMQPDecimal *) unwrapDecimal : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPDecimal32Type && tlv.type != IBAMQPDecimal64Type && tlv.type != IBAMQPDecimal128Type) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    return [[IBAMQPDecimal alloc] initWithValue:tlv.value];
}

+ (int) unwrapChar : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPCharType) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    return [tlv.value readInt];
}

+ (NSString *) unwrapString : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPString8Type && tlv.type != IBAMQPString32Type) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    return [[NSString alloc] initWithData:tlv.value encoding:NSUTF8StringEncoding];
}

+ (IBAMQPSymbol *) unwrapSymbol : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPSymbol8Type && tlv.type != IBAMQPSymbol32Type) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    NSString *string = [[NSString alloc] initWithData:tlv.value encoding:NSUTF8StringEncoding];
    return [[IBAMQPSymbol alloc] initWithString:string];
}

+ (NSData *) unwrapData : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPBinary8Type && tlv.type != IBAMQPBinary32Type) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    return tlv.value;
}

+ (NSUUID *) unwrapUUID : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPUUIDType) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    NSString *string = [[NSString alloc] initWithData:tlv.value encoding:NSUTF8StringEncoding];
    return [[NSUUID alloc] initWithUUIDString:string];
}

+ (NSArray *) unwrapList : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPList0Type && tlv.type != IBAMQPList8Type && tlv.type != IBAMQPList32Type) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    NSMutableArray *result = [NSMutableArray array];
    for (IBTLVAMQP *item in ((IBAMQPTLVList *)tlv).list) {
        [result addObject:[self unwrap:item]];
    }
    return result;
}

+ (NSDictionary *) unwrapMap : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPMap8Type && tlv.type != IBAMQPMap32Type) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    IBAMQPTLVMap *map = ((IBAMQPTLVMap *)tlv);
        
    for (IBTLVAMQP *key in map.map.allKeys) {
        IBTLVAMQP *value = [map.map objectForKey:key];
        if (value != nil) {
            [result setObject:[self unwrap:value] forKey:[self unwrap:key]];
        }
    }
    return result;
}

+ (NSArray *) unwrapArray : (IBTLVAMQP *) tlv {
    if (tlv.type != IBAMQPArray8Type && tlv.type != IBAMQPArray32Type) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    NSMutableArray *result = [NSMutableArray array];
    for (IBTLVAMQP *item in ((IBAMQPTLVArray *)tlv).elements) {
        [result addObject:[self unwrap:item]];
    }
    return result;
}

+ (id) unwrap : (IBTLVAMQP *) value {

    switch (value.type) {
        case IBAMQPNullType:
            return nil;
            break;
            
        case IBAMQPArray32Type:
        case IBAMQPArray8Type:
            return [self unwrapArray:value];
            break;
            
        case IBAMQPBinary8Type:
        case IBAMQPBinary32Type:
            return [self unwrapData:value];
            break;
            
        case IBAMQPUByteType:
            return @([self unwrapUByte:value]);
            break;
            
        case IBAMQPBooleanType:
        case IBAMQPBooleanTrueType:
        case IBAMQPBooleanFalseType:
            return @([self unwrapBOOL:value]);
            break;
            
        case IBAMQPByteType:
            return @([self unwrapByte:value]);
            break;
            
        case IBAMQPCharType:
            return @([self unwrapChar:value]);
            break;
            
        case IBAMQPDoubleType:
            return @([self unwrapDouble:value]);
            break;
         
        case IBAMQPFloatType:
            return @([self unwrapFloat:value]);
            break;
            
        case IBAMQPIntType:
        case IBAMQPSmallIntType:
            return @([self unwrapInt:value]);
            break;
            
        case IBAMQPList0Type:
        case IBAMQPList8Type:
        case IBAMQPList32Type:
            return [self unwrapList:value];
            break;
            
        case IBAMQPLongType:
        case IBAMQPSmallLongType:
            return @([self unwrapLong:value]);
            break;
            
        case IBAMQPMap8Type:
        case IBAMQPMap32Type:
            return [self unwrapMap:value];
            break;
            
        case IBAMQPShortType:
            return @([self unwrapShort:value]);
            break;
          
        case IBAMQPString8Type:
        case IBAMQPString32Type:
            return [self unwrapString:value];
            break;
            
        case IBAMQPSymbol8Type:
        case IBAMQPSymbol32Type:
            return [self unwrapSymbol:value];
            break;
            
        case IBAMQPTimestampType:
            return [self unwrapTimestamp:value];
            break;
           
        case IBAMQPUIntType:
        case IBAMQPSmallUIntType:
        case IBAMQPUInt0Type:
            return @([self unwrapUInt:value]);
            break;
            
        case IBAMQPULongType:
        case IBAMQPSmallULongType:
        case IBAMQPULong0Type:
            return @([self unwrapULong:value]);
            break;
            
        case IBAMQPUShortType:
            return @([self unwrapUShort:value]);
            break;
           
        case IBAMQPUUIDType:
            return [self unwrapUUID:value];
            break;
            
        case IBAMQPDecimal32Type:
        case IBAMQPDecimal64Type:
        case IBAMQPDecimal128Type:
            return [self unwrapDecimal:value];
            break;
            
        default:
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            break;
    }
    
    return nil;
}

@end
