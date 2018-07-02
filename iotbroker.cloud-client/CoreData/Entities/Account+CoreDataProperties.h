//
//  Account+CoreDataProperties.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 14.06.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//
//

#import "Account+CoreDataClass.h"
#import "IBProtocolTypeEnum.h"


NS_ASSUME_NONNULL_BEGIN

@interface Account (CoreDataProperties)

+ (NSFetchRequest<Account *> *)fetchRequest;

@property (nonatomic) BOOL cleanSession;
@property (nullable, nonatomic, copy) NSString *clientID;
@property (nonatomic) BOOL isDefault;
@property (nonatomic) BOOL isRetain;
@property (nonatomic) int32_t keepalive;
@property (nullable, nonatomic, copy) NSString *password;
@property (nonatomic) int64_t port;
@property (nonatomic) int16_t protocol;
@property (nonatomic) int32_t qos;
@property (nullable, nonatomic, copy) NSString *serverHost;
@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, copy) NSString *will;
@property (nullable, nonatomic, copy) NSString *willTopic;
@property (nonatomic) BOOL isSecure;
@property (nullable, nonatomic, copy) NSString *keyPath;
@property (nullable, nonatomic, copy) NSString *keyPass;
@property (nullable, nonatomic, retain) NSSet<Message *> *messages;
@property (nullable, nonatomic, retain) NSSet<Topic *> *topics;

@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSSet<Message *> *)values;
- (void)removeMessages:(NSSet<Message *> *)values;

- (void)addTopicsObject:(Topic *)value;
- (void)removeTopicsObject:(Topic *)value;
- (void)addTopics:(NSSet<Topic *> *)values;
- (void)removeTopics:(NSSet<Topic *> *)values;

@end

@interface Account (CoreDataValueValidation)

- (BOOL) isValid;

@end


NS_ASSUME_NONNULL_END
