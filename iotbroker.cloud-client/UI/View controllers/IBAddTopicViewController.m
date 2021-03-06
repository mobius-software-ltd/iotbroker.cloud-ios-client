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

#import "IBAddTopicViewController.h"
#import "IBPickerView.h"

@interface IBAddTopicViewController ()  <IBPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *topicTextField;
@property (weak, nonatomic) IBOutlet UITextField *qosValueTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation IBAddTopicViewController
{
    IBPickerView *_pickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self->_pickerView = [[IBPickerView alloc] initWithFrame:CGRectZero];
    self->_pickerView.ibDelegate = self;
    
    [self->_pickerView setValues:@[@0,@1,@2]];
    
    self.qosValueTextField.delegate = self;
    [self.qosValueTextField setInputView:self->_pickerView];
    [self.qosValueTextField setInputAccessoryView:[IBPickerView toolbarWithTarget:self selector:@selector(doneButtonClicker)]];
    
    self.topicTextField.delegate = self;
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.32];
    self.mainView.layer.masksToBounds = true;
    NSInteger radius = (NSInteger)self.view.frame.size.width / 30;
    
    self.mainView.layer.cornerRadius = radius;
    
    [self showAnimate];
}

- (void)doneButtonClicker {
    self.qosValueTextField.text = self.qosValueTextField.text.length == 0 ? @"0" : self.qosValueTextField.text;
    [self.qosValueTextField resignFirstResponder];
}

- (IBAction) addButtonClick:(id)sender {

    if ([sender isKindOfClass:[UIButton class]]) {
        if (self.topicTextField.text.length == 0 || self.qosValueTextField.text.length == 0) {
            [self setErrorMessage:@"Empty text fields. Please fill all fields"];
        } else {
            [self removeAnimate];
            [self.delegate addTopicViewControllerClickOnAddButton:self];
        }
    }
}

- (void) setErrorMessage : (NSString *) message {
    
    self.errorMessageLabel.text = message;
    
    [UIView animateWithDuration:1.0 animations:^{
        self.errorMessageLabel.alpha = 1.0;
    }];
    
    [UIView animateWithDuration:4.0 delay:1.0 options:0 animations:^{
        self.errorMessageLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished == true) {
            [UIView animateWithDuration:1.0 animations:^{
                self.errorMessageLabel.alpha = 1.0;
            }];
            self.errorMessageLabel.text = @"add new topic";
        }
    }];
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

- (NSString *)topicName {
    return self->_topicTextField.text;
}

- (NSInteger)qosValue {
    return [self->_qosValueTextField.text integerValue];
}

- (void)setTopicName:(NSString *)topicName {
    self->_topicTextField.text = topicName;
}

- (void)setQosValue:(NSInteger)qosValue {
    self->_qosValueTextField.text = [@(qosValue) stringValue];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if ([self.mainView isEqual:(touches.allObjects.firstObject.view)] == false) {
        [self removeAnimate];
    }
    [self.nextResponder touchesEnded:touches withEvent:event];
}

#pragma mark - IBPickerViewDelegate

- (void)pickerView:(IBPickerView *)view didSelectValue:(NSObject *)value {
    
    NSString *string = [((NSNumber *)value) stringValue];
    self.qosValueTextField.text = string;
    [self.qosValueTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [self.topicTextField resignFirstResponder];
}

@end
