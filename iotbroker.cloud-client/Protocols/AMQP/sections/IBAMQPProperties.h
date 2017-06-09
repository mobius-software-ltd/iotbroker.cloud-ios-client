//
//  IBAMQPProperties.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPSection.h"
#import "IBAMQPMessageID.h"
#import "IBMutableData.h"

@interface IBAMQPProperties : NSObject <IBAMQPSection>

@property (strong, nonatomic) id<IBAMQPMessageID> messageID;
@property (strong, nonatomic) NSMutableData *userID;
@property (strong, nonatomic) NSString *to;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *replyTo;
@property (strong, nonatomic) NSMutableData *correlationID;
@property (strong, nonatomic) NSString *contentType;
@property (strong, nonatomic) NSString *contentEncoding;
@property (strong, nonatomic) NSDate *absoluteExpiryTime;
@property (strong, nonatomic) NSDate *creationTime;
@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSNumber *groupSequence;
@property (strong, nonatomic) NSString *replyToGroupId;

@end
