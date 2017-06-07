//
//  IBAMQPAccepted.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPAccepted.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPTLVFixed.h"

@implementation IBAMQPAccepted

- (IBAMQPTLVList *)list {
    
    IBAMQPTLVList *tlvList = [[IBAMQPTLVList alloc] init];
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPSmallULongType];
    NSMutableData *data = [NSMutableData data];
    [data appendByte:(Byte)0x24];
    
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:[[IBAMQPType alloc] initWithType:tlvList.type]
                                                                                 andDescriptor:[[IBAMQPTLVFixed alloc] initWithType:type andValue:data]];
    tlvList.constructor = constructor;
    
    return tlvList;
}

- (void)fill:(IBAMQPTLVList *)list {

}

@end
