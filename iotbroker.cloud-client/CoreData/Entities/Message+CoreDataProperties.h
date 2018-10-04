//
//  Message+CoreDataProperties.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 02.10.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//
//

#import "Message+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *content;
@property (nonatomic) BOOL isDup;
@property (nonatomic) BOOL isIncoming;
@property (nonatomic) BOOL isRetain;
@property (nonatomic) int32_t qos;
@property (nullable, nonatomic, copy) NSString *topicName;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, retain) Account *account;

- (BOOL) isValid;

@end

NS_ASSUME_NONNULL_END
