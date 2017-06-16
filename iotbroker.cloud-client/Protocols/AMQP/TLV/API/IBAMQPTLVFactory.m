//
//  IBAMQPTLVFactory.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPTLVFactory.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPTLVVariable.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPTLVArray.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVNull.h"
#import "IBAMQPTLVMap.h"

@implementation IBAMQPTLVFactory

+ (IBTLVAMQP *) tlvByData : (NSMutableData *) data {

    IBAMQPSimpleConstructor *constructor = [IBAMQPTLVFactory constructorByData:data];
    
    IBTLVAMQP *tlv = [IBAMQPTLVFactory elementByConstructor:constructor andData:data];
    return tlv;
}

+ (IBTLVAMQP *) elementByConstructor : (IBAMQPSimpleConstructor *) constructor andData : (NSMutableData *) data {
    
    IBTLVAMQP *tlv = nil;
    
    IBAMQPType *type = constructor.type;
        
    switch (type.value) {
        case IBAMQPNullType:
            tlv = [[IBAMQPTLVNull alloc] init];
            break;
            
        case IBAMQPBooleanTrueType:
        case IBAMQPBooleanFalseType:
        case IBAMQPUInt0Type:
        case IBAMQPULong0Type:
            tlv = [[IBAMQPTLVFixed alloc] initWithType:type andValue:[NSMutableData data]];
            break;
            
        case IBAMQPBooleanType:
        case IBAMQPUByteType:
        case IBAMQPByteType:
        case IBAMQPSmallUIntType:
        case IBAMQPSmallIntType:
        case IBAMQPSmallULongType:
        case IBAMQPSmallLongType: {
            NSMutableData *bytes = [NSMutableData data];
            [bytes appendByte:[data readByte]];
            tlv = [[IBAMQPTLVFixed alloc] initWithType:type andValue:bytes];
            break;
        }
        case IBAMQPShortType:
        case IBAMQPUShortType: {
            NSMutableData *bytes = [NSMutableData data];
            [bytes appendShort:[data readShort]];
            tlv = [[IBAMQPTLVFixed alloc] initWithType:type andValue:bytes];
            break;
        }
        case IBAMQPUIntType:
        case IBAMQPIntType:
        case IBAMQPFloatType:
        case IBAMQPDecimal32Type:
        case IBAMQPCharType: {
            NSMutableData *bytes = [NSMutableData data];
            [bytes appendInt:[data readInt]];
            tlv = [[IBAMQPTLVFixed alloc] initWithType:type andValue:bytes];
            break;
        }
        case IBAMQPULongType:
        case IBAMQPLongType:
        case IBAMQPDecimal64Type:
        case IBAMQPDoubleType:
        case IBAMQPTimestampType: {
            NSMutableData *bytes = [NSMutableData data];
            [bytes appendLong:[data readLong]];
            tlv = [[IBAMQPTLVFixed alloc] initWithType:type andValue:bytes];
            break;
        }
        case IBAMQPDecimal128Type:
        case IBAMQPUUIDType: {
            NSMutableData *bytes = [NSMutableData data];
            [bytes appendData:[data subdataWithRange:NSMakeRange([data getByteNumber], 16)]];
            tlv = [[IBAMQPTLVFixed alloc] initWithType:type andValue:bytes];
            break;
        }
        case IBAMQPString8Type:
        case IBAMQPSymbol8Type:
        case IBAMQPBinary8Type: {
            int var8Length = ([data readByte] & 0xff);
            NSMutableData *bytes = [NSMutableData data];
            [bytes appendData:[data dataWithLength:var8Length]];
            tlv = [[IBAMQPTLVVariable alloc] initWithType:type andValue:bytes];
            break;
        }
        case IBAMQPString32Type:
        case IBAMQPSymbol32Type:
        case IBAMQPBinary32Type: {
            int var32Length = [data readInt];
            NSMutableData *bytes = [NSMutableData data];
            [bytes appendData:[data dataWithLength:var32Length]];
            tlv = [[IBAMQPTLVVariable alloc] initWithType:type andValue:bytes];
            break;
        }
        case IBAMQPList0Type:
            tlv = [[IBAMQPTLVList alloc] init];
            break;
            
        case IBAMQPList8Type: {
            [data readByte]; // list8size
            int list8count = ([data readByte] & 0xff);
            NSMutableArray<IBTLVAMQP *> *list8values = [NSMutableArray array];
            for (int i = 0; i < list8count; i++) {
                [list8values addObject:[IBAMQPTLVFactory tlvByData:data]];
            }
            tlv = [[IBAMQPTLVList alloc] initWithType:type andValue:list8values];
            break;
        }
        case IBAMQPList32Type: {
            [data readInt]; // list32size
            int list32count = [data readInt];
            NSMutableArray<IBTLVAMQP *> *list32values = [NSMutableArray array];
            for (int i = 0; i < list32count; i++) {
                [list32values addObject:[IBAMQPTLVFactory tlvByData:data]];
            }
            tlv = [[IBAMQPTLVList alloc] initWithType:type andValue:list32values];
            break;
        }
        case IBAMQPMap8Type: {
            int map8size = ([data readByte] & 0xff);
            [data readByte]; // map8count

            int stop8 = (int)[data getByteNumber] + map8size - 1;
            
            IBAMQPTLVMap *map8 = [[IBAMQPTLVMap alloc] init];
            
            while ([data getByteNumber] < stop8) {
                IBTLVAMQP *key = [IBAMQPTLVFactory tlvByData:data];
                IBTLVAMQP *value = [IBAMQPTLVFactory tlvByData:data];
                
                [map8 putElementWithKey:key andValue:value];
            }
            tlv = map8;
            
            break;
        }
        case IBAMQPMap32Type: {
            int map32size = [data readInt];
            [data readInt]; // map32count
            int stop32 = (int)[data getByteNumber] + map32size - 4;
            NSMutableDictionary *map32 = [NSMutableDictionary dictionary];
            while ([data getByteNumber] < stop32) {
                [map32 setObject:[IBAMQPTLVFactory tlvByData:data] forKey:[IBAMQPTLVFactory tlvByData:data]];
            }
            tlv = [[IBAMQPTLVMap alloc] initWithType:type andMap:map32];
            break;
        }
        case IBAMQPArray8Type: {
            NSMutableArray<IBTLVAMQP *> *array8 = [NSMutableArray array];
            [data readByte]; // array8size
            int array8count = ([data readByte] & 0xff);
            IBAMQPSimpleConstructor *array8Constructor = [self constructorByData:data];
            for (int i = 0; i < array8count; i++) {
                [array8 addObject:[IBAMQPTLVFactory elementByConstructor:array8Constructor andData:data]];
            }
            tlv = [[IBAMQPTLVArray alloc] initWithType:type andElements:array8];
            break;
        }
        case IBAMQPArray32Type: {
            NSMutableArray<IBTLVAMQP *> *array32 = [NSMutableArray array];
            [data readInt]; // array32size
            int array32count = [data readInt];
            IBAMQPSimpleConstructor *array32Constructor = [self constructorByData:data];
            for (int i = 0; i < array32count; i++) {
                [array32 addObject:[IBAMQPTLVFactory elementByConstructor:array32Constructor andData:data]];
            }
            tlv = [[IBAMQPTLVArray alloc] initWithType:type andElements:array32];
            break;
        }
        case IBAMQPErrorType:
        case IBAMQPSourceType:
        case IBAMQPTargetType:
            break;
    }
    
    if ([constructor isKindOfClass:[IBAMQPDescribedConstructor class]]) {
        tlv.constructor = constructor;
    }
    
    return tlv;
}

+ (IBAMQPSimpleConstructor *) constructorByData : (NSMutableData *) data {

    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPNullType];
    IBAMQPSimpleConstructor *constructor = nil;
    Byte codeByte = [data readByte];
    
    if (codeByte == 0) {
        IBTLVAMQP *descriptor = [IBAMQPTLVFactory tlvByData:data];
        type.value = ([data readByte] & 0xff);
        constructor = [[IBAMQPDescribedConstructor alloc] initWithType:type andDescriptor:descriptor];
    } else {
        type.value = (codeByte & 0xff);
        constructor = [[IBAMQPSimpleConstructor alloc] initWithType:type];
    }
    
    return constructor;
}

@end
