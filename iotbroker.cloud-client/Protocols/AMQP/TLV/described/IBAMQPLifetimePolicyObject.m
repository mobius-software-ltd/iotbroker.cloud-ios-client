//
//  IBAMQPLifetimePolicyObject.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPLifetimePolicyObject.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPTLVFixed.h"

@implementation IBAMQPLifetimePolicyObject

- (instancetype) initWithCode : (IBAMQPLifetimePolicies) code {
    self = [super init];
    if (self != nil) {
        self->_code = code;
    }
    return self;
}

- (IBAMQPTLVList *)list {
    
    
    IBAMQPTLVList *tlvList = [[IBAMQPTLVList alloc] init];
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPSmallULongType];
    NSMutableData *data = [NSMutableData data];
    [data appendByte:(Byte)self.code];
    
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:[[IBAMQPType alloc] initWithType:tlvList.type]
                                                                                 andDescriptor:[[IBAMQPTLVFixed alloc] initWithType:type andValue:data]];
    tlvList.constructor = constructor;
    return tlvList;
}

- (void)fill:(IBAMQPTLVList *)list {
    
    if (!list.isNull) {
        IBAMQPDescribedConstructor *constructor = (IBAMQPDescribedConstructor *)list.constructor;
        self.code = (constructor.descriptorCode & 0xff);
    }
}

@end
