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

#import "IBCoreDataManager.h"

@implementation IBCoreDataManager

@synthesize persistentContainer     = _persistentContainer;
@synthesize managedObjectModel      = _managedObjectModel;
@synthesize managedObjectContext    = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (id) init {
    self = [super init];
    if (self != nil) {
    }
    return self;
}

+ (instancetype) getInstance {
    static IBCoreDataManager *sharedDatabase = nil;
    @synchronized(self) {
        if (sharedDatabase == nil)
            sharedDatabase = [[self alloc] init];
    }
    return sharedDatabase;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iotbroker_cloud_client" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (self->_managedObjectContext != nil) {
        return self->_managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        self->_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [self->_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return self->_managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (self->_persistentStoreCoordinator != nil) {
        return self->_persistentStoreCoordinator;
    }
    
    NSURL *urlForMacTest = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *urlForIOS = [self applicationDocumentsDirectory];
    
    NSURL *url = urlForMacTest;
    
    NSURL *storeURL = [url URLByAppendingPathComponent:@"iotbroker_cloud_client.sqlite"];
    NSLog(@"URL : %@", storeURL.absoluteString);
    
    NSError *error = nil;
    self->_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"persistentStoreCoordinator : Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (self->_persistentContainer == nil) {
            self->_persistentContainer = [[NSPersistentContainer alloc] initWithName:@"iotbroker_cloud_client"];
            [self->_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"persistentContainer : Unresolved error %@, %@", error, error.userInfo);
                    //abort();
                }
            }];
        }
    }
    return self->_persistentContainer;
}

- (NSURL *) applicationDocumentsDirectory {
    
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@", NSTemporaryDirectory()];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:outputPath];
    
    return url;
}

- (NSManagedObject *) entity : (IBEntities) entity {

    NSManagedObject *entityObject = nil;
    
    if (entity == IBAccountEntity) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:self.managedObjectContext];
        entityObject = [[Account alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
    } else if (entity == IBMessageEntity) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
        entityObject = [[Message alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
    } else if (entity == IBTopicEntity) {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Topic" inManagedObjectContext:self.managedObjectContext];
        entityObject = [[Topic alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
    }
    
    return entityObject;
}

- (NSManagedObject *) entityForInserting : (IBEntities) entity {
    
    NSManagedObject *object = nil;
    
    @synchronized (self) {
        switch (entity) {
            case IBAccountEntity:   object = [NSEntityDescription insertNewObjectForEntityForName:@"Account"    inManagedObjectContext:self.managedObjectContext]; break;
            case IBMessageEntity:   object = [NSEntityDescription insertNewObjectForEntityForName:@"Message"    inManagedObjectContext:self.managedObjectContext]; break;
            case IBTopicEntity:     object = [NSEntityDescription insertNewObjectForEntityForName:@"Topic"      inManagedObjectContext:self.managedObjectContext]; break;
            default: break;
        }
    }
    return object;
}

- (NSArray *) getEntities : (IBEntities) entity {
    
    NSFetchRequest *request = nil;
    NSError *error = nil;
    NSArray *result = nil;
    
    @synchronized (self) {
        
        switch (entity) {
            case IBAccountEntity:   request = [Account fetchRequest];   break;
            case IBMessageEntity:   request = [Message fetchRequest];   break;
            case IBTopicEntity:     request = [Topic fetchRequest];     break;
            default: break;
        }
        result = [self.managedObjectContext executeFetchRequest:request error:&error];
    }
    
    if (result != nil) {
        return result;
    }
    NSLog(@"MANAGER : error");
    return nil;
}

- (void) deleteEntity : (NSManagedObject *) entity {
    
    if ([entity isKindOfClass:[Account class]]) {
        @synchronized (self) {
            [self.managedObjectContext deleteObject:(Account *)entity];
        }
    } else if ([entity isKindOfClass:[Message class]]) {
        @synchronized (self) {
            [self.managedObjectContext deleteObject:(Message *)entity];
        }
    } else if ([entity isKindOfClass:[Topic class]]) {
        @synchronized (self) {
            [self.managedObjectContext deleteObject:(Topic *)entity];
        }
    }  else {
        NSLog(@"DELETE ERROR!");
    }
}

- (BOOL) save {
    
    NSError *error = nil;
    BOOL result = false;
    
    @synchronized (self) {
        result = [self.managedObjectContext save:&error];
    }

    if (result == true) {
        return true;
    } else {
        NSLog(@"SAVE ERROR : %@", error.description);
        return false;
    }
}

@end
