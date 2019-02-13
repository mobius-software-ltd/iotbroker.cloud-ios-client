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

#import "IBAccountManager.h"

NSComparisonResult dateSort(Message *m1, Message *m2, void *context) {
    return [m2.date compare:m1.date];
}

@implementation IBAccountManager

- (id) init {
    self = [super init];
    if (self != nil) {
        self->_coreDataManager = [IBCoreDataManager getInstance];
    }
    return self;
}

+ (instancetype) getInstance {
    static IBAccountManager *sharedAccountManager = nil;
    @synchronized(self) {
        if (sharedAccountManager == nil)
            sharedAccountManager = [[self alloc] init];
    }
    return sharedAccountManager;
}

- (NSArray<Account *> *) accounts {
    return [self->_coreDataManager getEntities:IBAccountEntity];
}

- (Account *) account {
    return (Account *)[self->_coreDataManager entity:IBAccountEntity];
}

- (Topic *) topic {
    return (Topic *)[self->_coreDataManager entity:IBTopicEntity];
}

- (Message *) message {
    return (Message *)[self->_coreDataManager entity:IBMessageEntity];
}

- (void) setDefaultAccountWithClientID : (NSString *) clientID {
    
    [self unselectDefaultAccount];
    
    Account *account = [self accountByClientID:clientID];
    [account setIsDefault:true];
    
    [self->_coreDataManager save];
}

- (Account *) accountByClientID : (NSString *) clientID {
    
    Account *account = nil;
    if (clientID != nil) {
        NSArray *accounts = [self->_coreDataManager getEntities:IBAccountEntity];
        for (Account *item in accounts) {
            if ([clientID isEqualToString:item.clientID]) {
                account = item;
            }
        }
    }
    return account;
}

- (Account *) readDefaultAccount {
    
    NSArray *accounts = [self->_coreDataManager getEntities:IBAccountEntity];
    
    if (accounts.count != 0) {
        for (Account *item in accounts) {
            if (item.isDefault == true) {
                return item;
            }
        }
    }
    return nil;
}

- (void) writeAccount : (Account *) account {
    
    if (account != nil) {
        
        Account *newAccount = nil;
        
        if ([self isAccountAlreadyExist:account] == true) {
            newAccount = [self accountByClientID:account.clientID];
        } else {
            newAccount = (Account *)[self->_coreDataManager entityForInserting:IBAccountEntity];
        }
        
        if (newAccount != nil) {
            [newAccount setProtocol:account.protocol];
            [newAccount setUsername:account.username];
            [newAccount setPassword:account.password];
            [newAccount setClientID:account.clientID];
            [newAccount setServerHost:account.serverHost];
            [newAccount setPort:account.port];
            [newAccount setCleanSession:account.cleanSession];
            [newAccount setKeepalive:account.keepalive];
            [newAccount setWill:account.will];
            [newAccount setWillTopic:account.willTopic];
            [newAccount setIsRetain:account.isRetain];
            [newAccount setQos:account.qos];
            [newAccount setIsDefault:account.isDefault];
            [newAccount setIsSecure:account.isSecure];
            [newAccount setKeyPath:account.keyPath];
            [newAccount setKeyPass:account.keyPass];
                        
            [self->_coreDataManager save];
        }
    }
}

- (BOOL) isAccountAlreadyExist : (Account *) account {
    BOOL result = false;
    NSArray *accounts = [self->_coreDataManager getEntities:IBAccountEntity];
    if (accounts.count != 0) {
        for (Account *item in accounts) {
            if ([item.clientID isEqualToString:account.clientID]) {
                result = true;
            }
        }
    }
    return result;
}

- (void) addTopicToCurrentAccount : (Topic *) topic {
    if (topic != nil) {
        Account *currentAccount = [self readDefaultAccount];
        Topic *findTopic = [self topicByTopicName:topic.topicName];
        if (findTopic != nil) {
            [currentAccount removeTopicsObject:findTopic];
        }
        Topic *topicToAdd = (Topic *)[self->_coreDataManager entityForInserting:IBTopicEntity];
        [topicToAdd setTopicName:topic.topicName];
        [topicToAdd setQos:(int32_t)topic.qos];
        if ([self readDefaultAccount] != nil) {
            [currentAccount addTopicsObject:topicToAdd];
        }
        [self->_coreDataManager save];
    }
}

- (void) deleteTopicByTopicName : (NSString *) name {
    if (name != nil) {
        NSArray *topics = [self->_coreDataManager getEntities:IBTopicEntity];
        for (Topic *item in topics) {
            if ([item.topicName isEqualToString:name]) {
                [self->_coreDataManager deleteEntity:item];
            }
        }
        [self->_coreDataManager save];
    }
}

- (void) unselectDefaultAccount {
    for (Account *account in [self accounts]) {
        account.isDefault = false;
    }
    [self->_coreDataManager save];
}

- (void) addMessageForDefaultAccount : (Message *) message {

    if (message != nil) {
        Message *messageToAdd = (Message *)[self->_coreDataManager entityForInserting:IBMessageEntity];
        
        [messageToAdd setContent:message.content];
        [messageToAdd setQos:(int32_t)message.qos];
        [messageToAdd setTopicName:message.topicName];
        [messageToAdd setIsIncoming:message.isIncoming];
        [messageToAdd setDate:[NSDate date]];
        
        Account *currentAccount = [self readDefaultAccount];
        if ([self readDefaultAccount] != nil) {
            [currentAccount addMessagesObject:messageToAdd];
        }
        
        [self->_coreDataManager save];
    }
}

- (NSArray<Topic *> *) topicsForCurrentAccount {
    return [self topicsForAccount:[self readDefaultAccount]];
}

- (NSArray<Message *> *) messagesForCurrentAccount {
    return [self messagesForAccount:[self readDefaultAccount]];
}

- (void) deleteAllTopicsForCurrentAccount {
    [self deleteTopicsForAccount:[self readDefaultAccount]];
}

- (void) deleteAllMessagesForCurrentAccount {
    [self deleteMessagesForAccount:[self readDefaultAccount]];
}

- (void) cleanSessionData {
    [self deleteAllTopicsForCurrentAccount];
}

- (BOOL) isTopicExist: (NSString *)name {
    for (Topic *topic in [self topicsForCurrentAccount]) {
        if ([topic.topicName isEqualToString:name]) {
            return true;
        }
    }
    return false;
}

- (void) deleteAccount:(Account *)account {
    [self deleteTopicsForAccount:account];
    [self deleteMessagesForAccount:account];
    [self->_coreDataManager deleteEntity:account];
    [self->_coreDataManager save];
}

#pragma mark - private method

- (NSArray<Topic *> *)topicsForAccount:(Account *)account {
    if (account != nil) {
        return [account.topics allObjects];
    }
    return nil;
}

- (NSArray<Message *> *)messagesForAccount:(Account *)account {
    if (account != nil) {
        return [account.messages.allObjects sortedArrayUsingFunction:dateSort context:nil];
    }
    return nil;
}

- (void)deleteTopicsForAccount:(Account *)account {
    for (Topic *topic in [self topicsForCurrentAccount]) {
        [self->_coreDataManager deleteEntity:topic];
    }
}

- (void)deleteMessagesForAccount:(Account *)account {
    for (Message *message in [self messagesForCurrentAccount]) {
        [self->_coreDataManager deleteEntity:message];
    }
}

- (Topic *) topicByTopicName: (NSString *)name {
    for (Topic *topic in [self topicsForCurrentAccount]) {
        if ([topic.topicName isEqualToString:name]) {
            return topic;
        }
    }
    return nil;
}

@end
