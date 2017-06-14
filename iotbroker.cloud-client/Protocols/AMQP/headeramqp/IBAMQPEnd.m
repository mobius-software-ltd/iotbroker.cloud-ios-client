//
//  IBAMQPEnd.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPEnd.h"
#import "IBAMQPTLVNull.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPEnd

- (instancetype)init {
    IBAMQPHeaderCode *code = [IBAMQPHeaderCode enumWithHeaderCode:IBAMQPEndHeaderCode];
    self = [super initWithCode:code];
    return self;
}

- (NSInteger) getLength {
    
    int length = 8;
    IBAMQPTLVList *arguments = [self arguments];
    length += arguments.length;
    
    return length;
}

- (NSInteger) getMessageType {
    return IBAMQPEndHeaderCode;
}

- (IBAMQPTLVList *)arguments {
    
    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_error != nil) {
        [list addElementWithIndex:0 element:[self->_error list]];
    } else {
        [list addElementWithIndex:0 element:[[IBAMQPTLVNull alloc] init]];
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
    
    if (list.list.count > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (!element.isNull) {
            if (element.type != IBAMQPList0Type && element.type != IBAMQPList8Type && element.type != IBAMQPList32Type) {
                @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            }
            self->_error = [[IBAMQPError alloc] init];
            [self->_error fill:((IBAMQPTLVList *)element)];
        }
    }
}

@end
