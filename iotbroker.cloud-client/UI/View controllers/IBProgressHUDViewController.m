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

#import "IBProgressHUDViewController.h"

@interface IBProgressHUDViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progress;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation IBProgressHUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.32];
    self.mainView.layer.masksToBounds = true;
    NSInteger radius = (NSInteger)self.view.frame.size.width / 30;
    
    self.mainView.layer.cornerRadius = radius;
    
    [self showAnimate];
    [self.progress startAnimating];
}

- (void) showWithMessage : (NSString *) text {
    
    NSInteger index = (self.parentController.selectedIndex >= self.parentController.viewControllers.count) ? 0 : self.parentController.selectedIndex;
    UIViewController *controller = [[self.parentController viewControllers] objectAtIndex:index];
    
    [controller addChildViewController:self];
    self.view.frame = controller.view.bounds;
    [controller.view addSubview:self.view];
    [self didMoveToParentViewController:controller];
    [self setText:text];
}

- (void) close {
    [self.progress stopAnimating];
    [self removeAnimate];
}

- (void)setText:(NSString *)text {
    self->_text = text;
    self->_textLabel.text = text;
}

- (void) showAnimate {
    
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1.0;
        self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void) removeAnimate {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        if (finished == true) {
            [self.view removeFromSuperview];
        }
    }];
}

@end
