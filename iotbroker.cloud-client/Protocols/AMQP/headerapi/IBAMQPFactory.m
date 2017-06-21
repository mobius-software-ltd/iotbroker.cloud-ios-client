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

#import "IBAMQPFactory.h"
#import "IBAMQPTLVFactory.h"

@implementation IBAMQPFactory

+ (IBAMQPHeader *) amqp : (NSMutableData *) data {
    
    IBTLVAMQP *list = [IBAMQPTLVFactory tlvByData:data];
        
    if (list.type != IBAMQPList0Type && list.type != IBAMQPList8Type && list.type != IBAMQPList32Type) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    IBAMQPHeader *header = nil;
    
    Byte byteCode = list.constructor.descriptorCode;
    IBAMQPHeaderCode *code = [IBAMQPHeaderCode enumWithHeaderCode:byteCode];
    
    switch (code.value) {
        case IBAMQPAttachHeaderCode:        header = [[IBAMQPAttach alloc] init];       break;
        case IBAMQPBeginHeaderCode:         header = [[IBAMQPBegin alloc] init];        break;
        case IBAMQPCloseHeaderCode:         header = [[IBAMQPClose alloc] init];        break;
        case IBAMQPDetachHeaderCode:        header = [[IBAMQPDetach alloc] init];       break;
        case IBAMQPDispositionHeaderCode:   header = [[IBAMQPDisposition alloc] init];  break;
        case IBAMQPEndHeaderCode:           header = [[IBAMQPEnd alloc] init];          break;
        case IBAMQPFlowHeaderCode:          header = [[IBAMQPFlow alloc] init];         break;
        case IBAMQPOpenHeaderCode:          header = [[IBAMQPOpen alloc] init];         break;
        case IBAMQPTransferHeaderCode:      header = [[IBAMQPTransfer alloc] init];     break;

        default:
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            break;
    }
    
    [header fillArguments:(IBAMQPTLVList *)list];
    
    return header;
}

+ (IBAMQPHeader *) sasl : (NSMutableData *) data {
    
    IBTLVAMQP *list = [IBAMQPTLVFactory tlvByData:data];

    if (list.type != IBAMQPList0Type && list.type != IBAMQPList8Type && list.type != IBAMQPList32Type) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    IBAMQPHeader *header = nil;

    Byte byteCode = list.constructor.descriptorCode;
    IBAMQPHeaderCode *code = [IBAMQPHeaderCode enumWithHeaderCode:byteCode];
    
    switch (code.value) {
        case IBAMQPChallengeHeaderCode:     header = [[IBAMQPSASLChallenge alloc] init];    break;
        case IBAMQPInitHeaderCode:          header = [[IBAMQPSASLInit alloc] init];         break;
        case IBAMQPMechanismsHeaderCode:    header = [[IBAMQPSASLMechanisms alloc] init];   break;
        case IBAMQPOutcomeHeaderCode:       header = [[IBAMQPSASLOutcome alloc] init];      break;
        case IBAMQPResponseHeaderCode:      header = [[IBAMQPSASLResponse alloc] init];     break;

        default:
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            break;
    }
    
    [header fillArguments:(IBAMQPTLVList *)list];

    return header;
}

+ (id<IBAMQPSection>) section : (NSMutableData *) data {

    IBTLVAMQP *value = [IBAMQPTLVFactory tlvByData:data];
    
    id<IBAMQPSection> section = nil;
    
    Byte byteCode = value.constructor.descriptorCode;
    IBAMQPSectionCode *code = [IBAMQPSectionCode enumWithSectionCode:byteCode];

    switch (code.value) {
        case IBAMQPApplicationPropertiesSectionCode:    section = [[IBAMQPApplicationProperties alloc] init];   break;
        case IBAMQPDataSectionCode:                     section = [[IBAMQPData alloc] init];                    break;
        case IBAMQPDeliveryAnnotationsSectionCode:      section = [[IBAMQPDeliveryAnnotation alloc] init];      break;
        case IBAMQPFooterSectionCode:                   section = [[IBAMQPFooter alloc] init];                  break;
        case IBAMQPHeaderSectionCode:                   section = [[IBAMQPMessageHeader alloc] init];           break;
        case IBAMQPMessageAnnotationsSectionCode:       section = [[IBAMQPMessageAnnotations alloc] init];      break;
        case IBAMQPPropertiesSectionCode:               section = [[IBAMQPProperties alloc] init];              break;
        case IBAMQPSequenceSectionCode:                 section = [[IBAMQPSequence alloc] init];                break;
        case IBAMQPValueSectionCode:                    section = [[IBAMQPValue alloc] init];                   break;
        
        default:
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];

            break;
    }
    
    [section fill:value];
    
    return section;
}

+ (id<IBAMQPState>) state : (IBAMQPTLVList *) list {

    id<IBAMQPState> state = nil;

    Byte byteCode = list.constructor.descriptorCode;
    IBAMQPStateCode *code = [IBAMQPStateCode enumWithStateCode:byteCode];
    
    switch (code.value) {
        case IBAMQPAcceptedStateCode:   state = [[IBAMQPAccepted alloc] init];   break;
        case IBAMQPModifiedStateCode:   state = [[IBAMQPModified alloc] init];   break;
        case IBAMQPReceivedStateCode:   state = [[IBAMQPReceived alloc] init];   break;
        case IBAMQPRejectedStateCode:   state = [[IBAMQPRejected alloc] init];   break;
        case IBAMQPReleasedStateCode:   state = [[IBAMQPReleased alloc] init];   break;

        default:
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            break;
    }
    
    return state;
}

+ (id<IBAMQPOutcome>) outcome : (IBAMQPTLVList *) list {
    
    id<IBAMQPOutcome> outcome = nil;

    Byte byteCode = list.constructor.descriptorCode;
    IBAMQPStateCode *code = [IBAMQPStateCode enumWithStateCode:byteCode];

    switch (code.value) {
        case IBAMQPAcceptedStateCode:   outcome = [[IBAMQPAccepted alloc] init];  break;
        case IBAMQPModifiedStateCode:   outcome = [[IBAMQPModified alloc] init];  break;
        case IBAMQPRejectedStateCode:   outcome = [[IBAMQPRejected alloc] init];  break;
        case IBAMQPReleasedStateCode:   outcome = [[IBAMQPReleased alloc] init];  break;

        default:
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            break;
    }
    
    return outcome;
}

@end
