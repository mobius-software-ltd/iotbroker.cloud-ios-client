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

#import "IBAccountManager.h"

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

- (void) setDefaultAccountWithUserame : (NSString *) name {
    
    Account *account = [self accountByUsername:name];
    [account setIsDefault:true];
    
    [self->_coreDataManager save];
}

- (Account *) accountByUsername : (NSString *) name {
    
    Account *account = nil;
    if (name != nil) {
        NSArray *accounts = [self->_coreDataManager getEntities:IBAccountEntity];
        for (Account *item in accounts) {
            if ([name isEqualToString:item.username]) {
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
            newAccount = [self accountByUsername:account.username];
        } else {
            newAccount = (Account *)[self->_coreDataManager entityForInserting:IBAccountEntity];
        }
        
        if (newAccount != nil) {
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
            
            [self->_coreDataManager save];
        }
    }
}

- (BOOL) isAccountAlreadyExist : (Account *) account {
    
    BOOL result = false;
    
    NSArray *accounts = [self->_coreDataManager getEntities:IBAccountEntity];
    
    if (accounts.count != 0) {
        for (Account *item in accounts) {
            if ([item.username isEqualToString:account.username]) {
                result = true;
            }
        }
    }
    return result;
}

- (void) addTopicToCurrentAccount : (IBTopic *) topic {

    if (topic != nil) {
        Topic *topicToAdd = (Topic *)[self->_coreDataManager entityForInserting:IBTopicEntity];
        
        Account *currentAccount = [self readDefaultAccount];
        if ([self readDefaultAccount] != nil) {
            [currentAccount addTopicsObject:topicToAdd];
        }
        
        [topicToAdd setTopicName:topic.name];
        [topicToAdd setQos:(int32_t)[topic.qos getValue]];
        
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

- (void) addIncoming : (BOOL) incoming message : (IBPublish *) message {

    if (message != nil) {
        Message *messageToAdd = (Message *)[self->_coreDataManager entityForInserting:IBMessageEntity];
        
        Account *currentAccount = [self readDefaultAccount];
        if ([self readDefaultAccount] != nil) {
            [currentAccount addMessagesObject:messageToAdd];
        }
        
        [messageToAdd setID:(int32_t)message.packetID];
        [messageToAdd setContent:message.content];
        [messageToAdd setQos:(int32_t)[message.topic.qos getValue]];
        [messageToAdd setTopicName:message.topic.name];
        [messageToAdd setIsIncoming:incoming];
        
        [self->_coreDataManager save];
    }
}

- (NSArray *) getTopicsForCurrentAccount {

    Account *currentAccount = [self readDefaultAccount];
    
    if (currentAccount != nil) {
        NSMutableArray *topics = nil;
        NSArray *array = currentAccount.topics.allObjects;
        
        if (array.count != 0) {
            topics = [NSMutableArray array];
        }
        
        for (Topic *item in array) {
            IBTopic *topic = [[IBTopic alloc] initWithName:item.topicName andQoS:[[IBQoS alloc] initWithValue:item.qos]];
            [topics addObject:topic];
        }
        return topics;
    }
    return nil;
}

- (NSArray *) getMessagesForCurrentAccount {

    Account *currentAccount = [self readDefaultAccount];
    
    if (currentAccount != nil) {
        return currentAccount.messages.allObjects;
    }
    return nil;
}

@end
