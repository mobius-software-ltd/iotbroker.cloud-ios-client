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

#import "IBAMQPSASLChallenge.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPSASLChallenge

- (instancetype)init {
    IBAMQPHeaderCode *code = [IBAMQPHeaderCode enumWithHeaderCode:IBAMQPChallengeHeaderCode];
    self = [super initWithCode:code];
    if (self != nil) {
        self->_challenge = [NSMutableData data];
        self.type = 1;
    }
    return self;
}

- (NSInteger) getLength {
    
    int length = 8;
    IBAMQPTLVList *arguments = [self arguments];
    length += arguments.length;
    
    return length;
}

- (NSInteger) getMessageType {
    return IBAMQPChallengeHeaderCode;
}

- (IBAMQPTLVList *)arguments {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_challenge == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    [list addElementWithIndex:0 element:[IBAMQPWrapper wrapBinary:self->_challenge]];

    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x42];
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
        self->_challenge = [NSMutableData dataWithData:[IBAMQPUnwrapper unwrapData:element]];
    }
}

@end
