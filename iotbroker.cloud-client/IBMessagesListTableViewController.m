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

#import "IBMessagesListTableViewController.h"

@implementation IBMessagesListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"ImageBackground"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    UITableView *tableView = (UITableView *)self.view;
    tableView.backgroundView = imageView;
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    
    self->_accountManager = [IBAccountManager getInstance];
    
    NSArray *messagesFromDatabase = [self->_accountManager getMessagesForCurrentAccount];
    if (messagesFromDatabase != nil) {
        self->_massages = [NSMutableArray arrayWithArray:messagesFromDatabase];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"Incoming messages list";
    
    NSArray *messagesFromDatabase = [self->_accountManager getMessagesForCurrentAccount];
    if (messagesFromDatabase != nil) {
        self->_massages = [NSMutableArray arrayWithArray:messagesFromDatabase];
    }
    [self.tableView reloadData];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->_massages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IBMessagesListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Message *item = [self->_massages objectAtIndex:indexPath.row];
    
    if (item.isIncoming == true) {
        [cell setMessageType:IBIncomingMessage];
    } else {
        [cell setMessageType:IBOutgoingMessage];
    }
    
    cell.topicNameLabel.text = item.topicName;
    cell.messageLabel.text = [[NSString alloc] initWithData:item.content encoding:NSUTF8StringEncoding];
    cell.qosLabel.text = [@(item.qos) stringValue];
    
    return cell;
}

@end
