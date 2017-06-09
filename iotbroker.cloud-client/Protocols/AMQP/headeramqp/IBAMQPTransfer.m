//
//  IBAMQPTransfer.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPTransfer.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPFactory.h"

@implementation IBAMQPTransfer

@synthesize code = _code;
@synthesize doff = _doff;
@synthesize type = _type;
@synthesize chanel = _chanel;

- (instancetype)init {
    IBAMQPHeaderCode *code = [IBAMQPHeaderCode enumWithHeaderCode:IBAMQPTransferHeaderCode];
    self = [self initWithCode:code];
    return self;
}

- (IBAMQPTLVList *)arguments {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_handle == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    [list addElementWithIndex:0 element:[IBAMQPWrapper wrapObject:self->_handle withType:IBAMQPUIntType]];
    
    if (self->_deliveryId != nil) {
        [list addElementWithIndex:1 element:[IBAMQPWrapper wrapObject:self->_deliveryId withType:IBAMQPUIntType]];
    }
    if (self->_deliveryTag != nil) {
        [list addElementWithIndex:2 element:[IBAMQPWrapper wrapBinary:self->_deliveryTag]];
    }
    if (self->_messageFormat != nil) {
        [list addElementWithIndex:3 element:[IBAMQPWrapper wrapObject:self->_messageFormat withType:IBAMQPUIntType]];
    }
    if (self->_settled != nil) {
        [list addElementWithIndex:4 element:[IBAMQPWrapper wrapObject:self->_settled withType:IBAMQPBooleanType]];
    }
    if (self->_more != nil) {
        [list addElementWithIndex:5 element:[IBAMQPWrapper wrapObject:self->_more withType:IBAMQPBooleanType]];
    }
    if (self->_rcvSettleMode != nil) {
        [list addElementWithIndex:6 element:[IBAMQPWrapper wrapObject:self->_rcvSettleMode withType:IBAMQPUByteType]];
    }
    if (self->_state != nil) {
        [list addElementWithIndex:7 element:self->_state.list];
    }
    if (self->_resume != nil) {
        [list addElementWithIndex:8 element:[IBAMQPWrapper wrapObject:self->_resume withType:IBAMQPBooleanType]];
    }
    if (self->_aborted != nil) {
        [list addElementWithIndex:9 element:[IBAMQPWrapper wrapObject:self->_aborted withType:IBAMQPBooleanType]];
    }
    if (self->_batchable != nil) {
        [list addElementWithIndex:10 element:[IBAMQPWrapper wrapObject:self->_batchable withType:IBAMQPBooleanType]];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:self.code.value];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:list.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    list.constructor = constructor;
    
    return list;
}

- (void)fillArguments:(IBAMQPTLVList *)list {

    NSInteger size = list.list.count;
    
    if (size == 0) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    if (size > 11) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    if (size > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (element.isNull) {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
        self->_handle = @([IBAMQPUnwrapper unwrapUInt:element]);
    }
    if (size > 1) {
        IBTLVAMQP *element = [list.list objectAtIndex:1];
        if (!element.isNull) {
            self->_deliveryId = @([IBAMQPUnwrapper unwrapUInt:element]);
        }
    }
    if (size > 2) {
        IBTLVAMQP *element = [list.list objectAtIndex:2];
        if (!element.isNull) {
            self->_deliveryTag = [NSMutableData dataWithData:[IBAMQPUnwrapper unwrapData:element]];
        }
    }
    if (size > 3) {
        IBTLVAMQP *element = [list.list objectAtIndex:3];
        if (!element.isNull) {
            self->_messageFormat = [[IBAMQPMessageFormat alloc] initWithValue:[IBAMQPUnwrapper unwrapUInt:element]];
        }
    }
    if (size > 4) {
        IBTLVAMQP *element = [list.list objectAtIndex:4];
        if (!element.isNull) {
            self->_settled = @([IBAMQPUnwrapper unwrapBOOL:element]);
        }
    }
    if (size > 5) {
        IBTLVAMQP *element = [list.list objectAtIndex:5];
        if (!element.isNull) {
            self->_more = @([IBAMQPUnwrapper unwrapBOOL:element]);
        }
    }
    if (size > 6) {
        IBTLVAMQP *element = [list.list objectAtIndex:6];
        if (!element.isNull) {
            self->_rcvSettleMode = [IBAMQPReceiverSettleMode enumWithReceiverSettleMode:[IBAMQPUnwrapper unwrapBOOL:element]];
        }
    }
    if (size > 7) {
        IBTLVAMQP *element = [list.list objectAtIndex:7];
        if (!element.isNull) {
            if (element.type != IBAMQPList0Type && element.type != IBAMQPList8Type && element.type != IBAMQPList32Type) {
                @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            }
            self->_state = [IBAMQPFactory state:(IBAMQPTLVList *)element];
            [self->_state fill:(IBAMQPTLVList *)element];
        }
    }
    if (size > 8) {
        IBTLVAMQP *element = [list.list objectAtIndex:8];
        if (!element.isNull) {
            self->_resume = @([IBAMQPUnwrapper unwrapBOOL:element]);
        }
    }
    if (size > 9) {
        IBTLVAMQP *element = [list.list objectAtIndex:9];
        if (!element.isNull) {
            self->_aborted = @([IBAMQPUnwrapper unwrapBOOL:element]);
        }
    }
    if (size > 10) {
        IBTLVAMQP *element = [list.list objectAtIndex:10];
        if (!element.isNull) {
            self->_batchable = @([IBAMQPUnwrapper unwrapBOOL:element]);
        }
    }
}

- (id<IBAMQPSection>) header {
    IBAMQPSectionCode *sectionCode = [IBAMQPSectionCode enumWithSectionCode:IBAMQPHeaderSectionCode];
    return [self->_sections objectForKey:sectionCode];
}

- (id<IBAMQPSection>) deliveryAnnotations {
    IBAMQPSectionCode *sectionCode = [IBAMQPSectionCode enumWithSectionCode:IBAMQPDeliveryAnnotationsSectionCode];
    return [self->_sections objectForKey:sectionCode];
}

- (id<IBAMQPSection>) messageAnnotations {
    IBAMQPSectionCode *sectionCode = [IBAMQPSectionCode enumWithSectionCode:IBAMQPMessageAnnotationsSectionCode];
    return [self->_sections objectForKey:sectionCode];
}

- (id<IBAMQPSection>) properties {
    IBAMQPSectionCode *sectionCode = [IBAMQPSectionCode enumWithSectionCode:IBAMQPPropertiesSectionCode];
    return [self->_sections objectForKey:sectionCode];
}

- (id<IBAMQPSection>) applicationProperties {
    IBAMQPSectionCode *sectionCode = [IBAMQPSectionCode enumWithSectionCode:IBAMQPApplicationPropertiesSectionCode];
    return [self->_sections objectForKey:sectionCode];
}

- (id<IBAMQPSection>) data {
    IBAMQPSectionCode *sectionCode = [IBAMQPSectionCode enumWithSectionCode:IBAMQPDataSectionCode];
    return [self->_sections objectForKey:sectionCode];
}

- (id<IBAMQPSection>) sequence {
    IBAMQPSectionCode *sectionCode = [IBAMQPSectionCode enumWithSectionCode:IBAMQPSequenceSectionCode];
    return [self->_sections objectForKey:sectionCode];
}

- (id<IBAMQPSection>) value {
    IBAMQPSectionCode *sectionCode = [IBAMQPSectionCode enumWithSectionCode:IBAMQPValueSectionCode];
    return [self->_sections objectForKey:sectionCode];
}

- (id<IBAMQPSection>) footer {
    IBAMQPSectionCode *sectionCode = [IBAMQPSectionCode enumWithSectionCode:IBAMQPFooterSectionCode];
    return [self->_sections objectForKey:sectionCode];
}

- (void) addSections : (NSArray<id<IBAMQPSection>> *) array {
    if (self->_sections == nil) {
        self->_sections = [NSMutableDictionary dictionary];
    }
    for (id<IBAMQPSection> item in array) {
        [self->_sections setObject:item forKey:item.code];
    }
}

@end
