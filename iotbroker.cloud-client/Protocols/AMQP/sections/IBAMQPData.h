//
//  IBAMQPData.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPSection.h"
#import "IBMutableData.h"

@interface IBAMQPData : NSObject <IBAMQPSection>

@property (strong, nonatomic, readonly) NSMutableData *data;

@end
