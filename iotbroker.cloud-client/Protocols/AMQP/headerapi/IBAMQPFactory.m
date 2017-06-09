//
//  IBAMQPFactory.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 08.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPFactory.h"
#import "IBAMQPTLVFactory.h"
#import "IBAMQPAttach.h"
#import "IBAMQPBegin.h"
#import "IBAMQPClose.h"
#import "IBAMQPDetach.h"
#import "IBAMQPDisposition.h"
#import "IBAMQPEnd.h"
#import "IBAMQPFlow.h"
#import "IBAMQPOpen.h"
#import "IBAMQPTransfer.h"
#import "IBAMQPSASLChallenge.h"
#import "IBAMQPSASLInit.h"
#import "IBAMQPSASLMechanisms.h"
#import "IBAMQPSASLOutcome.h"
#import "IBAMQPSASLResponse.h"
#import "IBAMQPApplicationProperties.h"
#import "IBAMQPData.h"
#import "IBAMQPDeliveryAnnotation.h"
#import "IBAMQPFooter.h"
#import "IBAMQPMessageHeader.h"
#import "IBAMQPMessageAnnotations.h"
#import "IBAMQPProperties.h"
#import "IBAMQPSequence.h"
#import "IBAMQPValue.h"

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
            break;
    }
    
    [section fill:value];
    
    return section;
}

@end
