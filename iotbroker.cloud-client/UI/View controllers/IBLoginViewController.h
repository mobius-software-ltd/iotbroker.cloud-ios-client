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
#import "Account+CoreDataClass.h"

@class IBLoginViewController;

@protocol IBLoginControllerDelegate <NSObject>

- (void) loginTableViewController : (IBLoginViewController *) loginTableViewController newAccountToAdd : (Account *) account;
- (void) loginTableViewControllerBackButtonDidClick : (IBLoginViewController *) loginTableViewController;
- (void) loginTableViewControllerProtocolCellDidClick : (IBLoginViewController *) loginTableViewController;
- (void) loginTableViewControllerKeyFieldSelected : (IBLoginViewController *) loginTableViewController;

@end

@interface IBLoginViewController : UIViewController

@property (weak, nonatomic) id<IBLoginControllerDelegate> delegate;
@property (strong, nonatomic) Account *account;
@property (assign, nonatomic) BOOL backButton;

- (void) setProtocolType : (IBProtocolsType) type;

@end
