/**
 * Mobius Software LTD
 * Copyright 2015-2016, Mobius Software LTD
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

#import "Account+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface Account (CoreDataProperties)

+ (NSFetchRequest<Account *> *)fetchRequest;

@property (nonatomic) BOOL cleanSession;
@property (nullable, nonatomic, copy) NSString *clientID;
@property (nonatomic) int32_t iD;
@property (nonatomic) BOOL isDefault;
@property (nonatomic) BOOL isRetain;
@property (nonatomic) int32_t keepalive;
@property (nullable, nonatomic, copy) NSString *password;
@property (nonatomic) int32_t qos;
@property (nullable, nonatomic, copy) NSString *serverHost;
@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, copy) NSString *will;
@property (nullable, nonatomic, copy) NSString *willTopic;
@property (nonatomic) int64_t port;
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

NS_ASSUME_NONNULL_END
