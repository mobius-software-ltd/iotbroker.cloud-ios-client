//
//  IBAMQPHeader.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPHeaderCode.h"
#import "IBAMQPTLVList.h"
#import "IBMessage.h"

@interface IBAMQPHeader : NSObject <IBMessage>

@property (strong, nonatomic) IBAMQPHeaderCode *code;

@property (assign, nonatomic) NSInteger doff;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger chanel;

- (instancetype) initWithCode : (IBAMQPHeaderCode *) code;
- (IBAMQPTLVList *) arguments;
- (void) fillArguments : (IBAMQPTLVList *) list;

@end
