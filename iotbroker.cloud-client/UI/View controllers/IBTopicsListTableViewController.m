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

#import "IBTopicsListTableViewController.h"
#import "IBTopicsListTableViewCell.h"
#import "IBDashBorderButton.h"

static NSString *const IBAddTopicPopover = @"IBAddTopicPopover";

@interface IBTopicsListTableViewController ()

@end

@implementation IBTopicsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"ImageBackground"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    UITableView *tableView = (UITableView *)self.view;
    tableView.backgroundView = imageView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"Topics list";
}

- (IBAction) addTopicButtonDidClick:(id)sender {
    [self.delegate topicsListTableViewControllerDidClickAddButton:self];
}

- (void)setTopics:(NSArray<Topic *> *)topics {
    self->_topics = topics;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->_topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IBTopicsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Topic *item = [self->_topics objectAtIndex:indexPath.row];
    cell.topicNameLabel.text = item.topicName;
    cell.qosLabel.text = [@(item.qos) stringValue];
    
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        Topic *topic = [self->_topics objectAtIndex:indexPath.row];
        [self.delegate topicsListTableViewController:self didClickDeleteButtonWithTopic:topic];
    }];
    delete.backgroundColor = [UIColor grayColor];
    
    return @[delete];
}

@end
