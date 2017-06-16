//
//  IBAMQPSequence.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPSequence.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPSequence

- (IBTLVAMQP *)value {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_sequence != nil) {
        list = (IBAMQPTLVList *)[IBAMQPWrapper wrapList:self->_sequence];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x76];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:list.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    list.constructor = constructor;
    
    return list;
}

- (void)fill:(IBTLVAMQP *)value {
    if (!value.isNull) {
        self->_sequence = [NSMutableArray arrayWithArray:[IBAMQPUnwrapper unwrapList:value]];
    }
}

- (IBAMQPSectionCode *)code {
    return [[IBAMQPSectionCode alloc] initWithSectionCode:IBAMQPSequenceSectionCode];
}

- (void) addSequence : (NSArray *) sequences {
    
    if (self->_sequence == nil) {
        self->_sequence = [NSMutableArray array];
    }
    for (NSObject *value in sequences) {
        [self->_sequence addObject:value];
    }
}

@end
