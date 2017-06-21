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

#import "IBAMQPProperties.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPLongID.h"
#import "IBAMQPStringID.h"
#import "IBAMQPBinaryID.h"
#import "IBAMQPUUID.h"

@implementation IBAMQPProperties

- (IBTLVAMQP *)value {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_messageID != nil) {
        NSObject *object = nil;
        if (self->_messageID.binary != nil) {
            object = self->_messageID.binary;
        } else if (self->_messageID.longValue != nil) {
            object = self->_messageID.longValue;
        } else if (self->_messageID.string != nil) {
            object = self->_messageID.string;
        } else if (self->_messageID.uuid != nil) {
            object = self->_messageID.uuid;
        }
        [list addElementWithIndex:0 element:[IBAMQPWrapper wrapObject:object]];
    }
    
    if (self->_userID != nil) {
        [list addElementWithIndex:1 element:[IBAMQPWrapper wrapBinary:self->_userID]];
    }
    if (self->_to != nil) {
        [list addElementWithIndex:2 element:[IBAMQPWrapper wrapString:self->_to]];
    }
    if (self->_subject != nil) {
        [list addElementWithIndex:3 element:[IBAMQPWrapper wrapString:self->_subject]];
    }
    if (self->_replyTo != nil) {
        [list addElementWithIndex:4 element:[IBAMQPWrapper wrapString:self->_replyTo]];
    }
    if (self->_correlationID != nil) {
        [list addElementWithIndex:5 element:[IBAMQPWrapper wrapBinary:self->_correlationID]];
    }
    if (self->_contentType != nil) {
        [list addElementWithIndex:6 element:[IBAMQPWrapper wrapString:self->_contentType]];
    }
    if (self->_contentEncoding != nil) {
        [list addElementWithIndex:7 element:[IBAMQPWrapper wrapString:self->_contentEncoding]];
    }
    if (self->_absoluteExpiryTime != nil) {
        [list addElementWithIndex:8 element:[IBAMQPWrapper wrapTimestamp:self->_absoluteExpiryTime]];
    }
    if (self->_creationTime != nil) {
        [list addElementWithIndex:9 element:[IBAMQPWrapper wrapTimestamp:self->_creationTime]];
    }
    if (self->_groupId != nil) {
        [list addElementWithIndex:10 element:[IBAMQPWrapper wrapString:self->_groupId]];
    }
    if (self->_groupSequence != nil) {
        [list addElementWithIndex:11 element:[IBAMQPWrapper wrapUInt:[self->_groupSequence unsignedIntValue]]];
    }
    if (self->_replyToGroupId != nil) {
        [list addElementWithIndex:12 element:[IBAMQPWrapper wrapString:self->_replyToGroupId]];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x73];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:list.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    list.constructor = constructor;
    
    return list;
}

- (void)fill:(IBTLVAMQP *)value {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];

    if (list.list.count > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (!element.isNull) {
            switch (element.type) {
                case IBAMQPULong0Type:
                case IBAMQPSmallULongType:
                case IBAMQPULongType:
                    self->_messageID = [[IBAMQPLongID alloc] initWithNumberID:@([IBAMQPUnwrapper unwrapLong:element])];
                    break;
                    
                case IBAMQPString8Type:
                case IBAMQPString32Type:
                    self->_messageID = [[IBAMQPStringID alloc] initWithStringID:[IBAMQPUnwrapper unwrapString:element]];
                    break;
                    
                case IBAMQPBinary8Type:
                case IBAMQPBinary32Type:
                    self->_messageID = [[IBAMQPBinaryID alloc] initWithBinaryID:[NSMutableData dataWithData:[IBAMQPUnwrapper unwrapData:element]]];
                    break;
                    
                case IBAMQPUUIDType:
                    self->_messageID = [[IBAMQPUUID alloc] initWithUUID:[IBAMQPUnwrapper unwrapUUID:element]];
                    break;
                    
                default:
                    @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
                    break;
            }
        }
    }
    if (list.list.count > 1) {
        IBTLVAMQP *element = [list.list objectAtIndex:1];
        if (!element.isNull) {
            self->_userID = [NSMutableData dataWithData:[IBAMQPUnwrapper unwrapData:element]];
        }
    }
    if (list.list.count > 2) {
        IBTLVAMQP *element = [list.list objectAtIndex:2];
        if (!element.isNull) {
            self->_to = [IBAMQPUnwrapper unwrapString:element];
        }
    }
    if (list.list.count > 3) {
        IBTLVAMQP *element = [list.list objectAtIndex:3];
        if (!element.isNull) {
            self->_subject = [IBAMQPUnwrapper unwrapString:element];
        }
    }
    if (list.list.count > 4) {
        IBTLVAMQP *element = [list.list objectAtIndex:4];
        if (!element.isNull) {
            self->_replyTo = [IBAMQPUnwrapper unwrapString:element];
        }
    }
    if (list.list.count > 5) {
        IBTLVAMQP *element = [list.list objectAtIndex:5];
        if (!element.isNull) {
            self->_correlationID = [NSMutableData dataWithData:[IBAMQPUnwrapper unwrapData:element]];
        }
    }
    if (list.list.count > 6) {
        IBTLVAMQP *element = [list.list objectAtIndex:6];
        if (!element.isNull) {
            self->_contentType = [IBAMQPUnwrapper unwrapString:element];
        }
    }
    if (list.list.count > 7) {
        IBTLVAMQP *element = [list.list objectAtIndex:7];
        if (!element.isNull) {
            self->_contentEncoding = [IBAMQPUnwrapper unwrapString:element];
        }
    }
    if (list.list.count > 8) {
        IBTLVAMQP *element = [list.list objectAtIndex:8];
        if (!element.isNull) {
            self->_absoluteExpiryTime = [IBAMQPUnwrapper unwrapTimestamp:element];
        }
    }
    if (list.list.count > 9) {
        IBTLVAMQP *element = [list.list objectAtIndex:9];
        if (!element.isNull) {
            self->_creationTime = [IBAMQPUnwrapper unwrapTimestamp:element];
        }
    }
    if (list.list.count > 10) {
        IBTLVAMQP *element = [list.list objectAtIndex:10];
        if (!element.isNull) {
            self->_groupId = [IBAMQPUnwrapper unwrapString:element];
        }
    }
    if (list.list.count > 11) {
        IBTLVAMQP *element = [list.list objectAtIndex:11];
        if (!element.isNull) {
            self->_groupSequence = @([IBAMQPUnwrapper unwrapUInt:element]);
        }
    }
    if (list.list.count > 12) {
        IBTLVAMQP *element = [list.list objectAtIndex:12];
        if (!element.isNull) {
            self->_replyToGroupId = [IBAMQPUnwrapper unwrapString:element];
        }
    }
}

- (IBAMQPSectionCode *)code {
    return [[IBAMQPSectionCode alloc] initWithSectionCode:IBAMQPPropertiesSectionCode];
}

@end
