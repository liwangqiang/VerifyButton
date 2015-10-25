//
//  ViewController.m
//  VertifyButton
//
//  Created by 李王强 on 15/10/24.
//  Copyright © 2015年 personal. All rights reserved.
//

#import "ViewController.h"
#import "VertifyButton.h"

@interface ViewController ()<VertifyButtonDelegate>

@property (weak, nonatomic) IBOutlet VertifyButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.button.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)verfityButton:(VertifyButton *)vertifyButton didTransformFromState:(VertifyButtonState)previousState toState:(VertifyButtonState)currentState
{
    if (previousState == VertifyButtonStateStandBy && currentState == VertifyButtonStateSending) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vertifyButton startCountingDown];
        });
    }
    
    if (previousState == VertifyButtonStateCountDown && currentState == VertifyButtonStateStandBy) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vertifyButton send];
        });
    }
    NSLog(@"did from %ld to %ld", previousState, currentState);
}

- (void)verfityButton:(VertifyButton *)vertifyButton willTransformFromState:(VertifyButtonState)previousState toState:(VertifyButtonState)currentState
{
    NSLog(@"will from %ld to %ld", previousState, currentState);
}

@end
