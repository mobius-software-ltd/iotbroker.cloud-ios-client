//
//  IBAMQPSASLResponse.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPSASLResponse.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPSASLResponse

- (instancetype)init {
    IBAMQPHeaderCode *code = [IBAMQPHeaderCode enumWithHeaderCode:IBAMQPResponseHeaderCode];
    self = [super initWithCode:code];
    self.type = 1;
    return self;
}

- (NSInteger) getLength {
    
    int length = 8;
    IBAMQPTLVList *arguments = [self arguments];
    length += arguments.length;
    
    return length;
}

- (NSInteger) getMessageType {
    return IBAMQPResponseHeaderCode;
}

- (IBAMQPTLVList *)arguments {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_response == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    [list addElementWithIndex:0 element:[IBAMQPWrapper wrapBinary:self->_response]];
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x43];
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
    
    if (size > 1) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    if (size > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (element.isNull) {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
        self->_response = [NSMutableData dataWithData:[IBAMQPUnwrapper unwrapData:element]];
    }
}

- (NSMutableData *) calcCramMD5 : (NSMutableData *) challenge user : (NSString *) user {
    if (challenge != nil && challenge.length != 0) {

    #warning MD5
        
    } else {
        return [NSMutableData data];
    }
    return nil;
}

- (void) setCramMD5Response : (NSMutableData *) challenge user : (NSString *) user {
    
    if (user == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    if (challenge == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    self->_response = [self calcCramMD5:challenge user:user];
}

@end
