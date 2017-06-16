//
//  IBAMQPFactory.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 08.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPOutcome.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPState.h"
#import "IBAMQPHeader.h"
#import "IBMutableData.h"
#import "IBAMQPSection.h"
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
#import "IBAMQPStateCode.h"
#import "IBAMQPAccepted.h"
#import "IBAMQPModified.h"
#import "IBAMQPReceived.h"
#import "IBAMQPRejected.h"
#import "IBAMQPReleased.h"

@interface IBAMQPFactory : NSObject

+ (IBAMQPHeader *) amqp : (NSMutableData *) data;
+ (IBAMQPHeader *) sasl : (NSMutableData *) data;
+ (id<IBAMQPSection>) section : (NSMutableData *) data;
+ (id<IBAMQPState>) state : (IBAMQPTLVList *) list;
+ (id<IBAMQPOutcome>) outcome : (IBAMQPTLVList *) list;

@end
