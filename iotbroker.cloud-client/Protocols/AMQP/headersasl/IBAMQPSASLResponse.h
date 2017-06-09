//
//  IBAMQPSASLResponse.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPHeader.h"
#import "IBMutableData.h"

@interface IBAMQPSASLResponse : IBAMQPHeader

@property (strong, nonatomic) NSMutableData *response;

- (NSMutableData *) calcCramMD5 : (NSMutableData *) challenge user : (NSString *) user;
- (void) setCramMD5Response : (NSMutableData *) challenge user : (NSString *) user;

@end
