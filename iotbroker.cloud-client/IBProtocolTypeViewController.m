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

#import "IBProtocolTypeViewController.h"

@interface IBProtocolTypeViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *mqttButton;
@property (weak, nonatomic) IBOutlet UIButton *mqttsnButton;

@end

@implementation IBProtocolTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.32];
    self.mainView.layer.masksToBounds = true;
    NSInteger radius = (NSInteger)self.view.frame.size.width / 30;
    
    self.mainView.layer.cornerRadius = radius;
    
    [self showAnimate];
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

- (IBAction) buttonDidClick:(id)sender {

    if ([sender isEqual:self.mqttButton]) {
        [self.delegate protocolTypeViewController:self didClickOnMqttButton:IBMqttProtocolType];
    } else if ([sender isEqual:self.mqttsnButton]) {
        [self.delegate protocolTypeViewController:self didClickOnMqttButton:IBMqttSNProtocolType];
    }
    [self removeAnimate];
}

@end
