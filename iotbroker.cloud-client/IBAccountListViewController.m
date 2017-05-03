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

#import "IBAccountListViewController.h"
#import "IBAccountListTableViewCell.h"

@interface IBAccountListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation IBAccountListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.32];
    self.mainView.layer.masksToBounds = true;
    NSInteger radius = (NSInteger)self.view.frame.size.width / 30;

    self.mainView.layer.cornerRadius = radius;
    
    [self showAnimate];
}

- (IBAction) addNewAccountButtonClick : (id)sender {
    [self removeAnimate];
    [self.delegate accountListViewControllerDidClickToCreateNewAccount:self];
}

- (void) showAnimate {

    self.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.view.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1.0;
        self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void) removeAnimate {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.view.alpha = 0.0;

    } completion:^(BOOL finished) {
        if (finished == true) {
            [self.view removeFromSuperview];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IBAccountListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Account *item = [self.accounts objectAtIndex:indexPath.row];
    
    IBProtocolTypeEnum *type = [[IBProtocolTypeEnum alloc] init];
    type.type = item.protocol;
    
    cell.protocolLabel.text = [type nameByValue];
    cell.clientIDLabel.text = item.clientID;
    cell.hostLabel.text = item.serverHost;
    cell.portLabel.text = [@(item.port) stringValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    Account *selectedAccount = [self.accounts objectAtIndex:indexPath.row];
    [self removeAnimate];
    [self.delegate accountListViewController:self didSelectedAccount:selectedAccount];
}

@end
