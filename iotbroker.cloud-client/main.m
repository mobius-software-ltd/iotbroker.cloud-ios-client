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

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "IBCoParser.h"
#import "IBCoAP.h"

int main(int argc, char * argv[]) {
    
    //IBCoMessage *message = [IBCoMessage method:IBPOSTMethod confirmableFlag:true tokenFlag:true andPayload:@"text"];
    //message.token = 1793507472;
    //message.type = IBConfirmableType;
    //message.messageID = 17836;
        
    //[message addOption:IBUriPathOption withValue:@"hello"];
    /*
    IBCoMessage *message1 = [IBCoParser decode:[IBCoParser encode:message]];

    NSLog(@"_%zd", message1.code);
    NSLog(@"%zd", message1.token);
    NSLog(@"%zd", message1.type);
    NSLog(@"%zd", message1.messageID);
    NSLog(@"%@_", message1.payload);
     */
    
    //IBCoAP *coap = [[IBCoAP alloc] initWithHost:@"134.102.218.18" port:5683 andResponseDelegate:nil];
    ///[coap prepareToSendingRequest];
    //[coap publishMessage:nil];
    
    
    
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
