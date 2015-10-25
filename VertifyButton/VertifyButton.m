//
//  VertifyButton.m
//  VertifyButton
//
//  Created by 李王强 on 15/10/24.
//  Copyright © 2015年 personal. All rights reserved.
//

#import "VertifyButton.h"

static NSString *const stateStandByDesc = @"发送验证码";
static NSString *const stateSendingDesc = @"正在发送";
static NSString *const stateCountDownDesc = @"等待重新发送(%ld)";
static NSInteger const initCountNumber = 5;

@interface VertifyButton ()
@property (nonatomic, assign, readwrite) VertifyButtonState currentState;
@end

@implementation VertifyButton{
    NSTimer *_resendTimer;
    NSInteger _countDown;
    VertifyButtonState _previousState;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit
{
    _previousState = VertifyButtonStateStandBy;
    _currentState = VertifyButtonStateStandBy;
    _countDown = initCountNumber;
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self setTitle:stateStandByDesc forState:UIControlStateNormal];
    [self addTarget:self action:@selector(clickEventHandler:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setCurrentState:(VertifyButtonState)currentState
{
    _previousState = _currentState;
    _currentState = currentState;
    
    switch (currentState) {
        case VertifyButtonStateStandBy:{
            
            [_resendTimer invalidate];
            _countDown = initCountNumber;
            
            [self willTransformFromState:_previousState ToState:_currentState];
            [self setEnabled:YES];
            [self setTitle:stateStandByDesc forState:UIControlStateNormal];
            [self didTransformFromState:_previousState ToState:_currentState];
        }
            break;
        case VertifyButtonStateSending:{
            [self willTransformFromState:_previousState ToState:_currentState];
            [self setEnabled:NO];
            [self setTitle:stateSendingDesc forState:UIControlStateDisabled];
            [self didTransformFromState:_previousState ToState:_currentState];
        }
            break;
        case VertifyButtonStateCountDown:{
            [self willTransformFromState:_previousState ToState:_currentState];
            [self setEnabled:NO];
            _resendTimer = [self makeNewResendTimer];
            [_resendTimer fire];
            [self didTransformFromState:_previousState ToState:_currentState];
        }
            break;
        default:
            break;
    }
}

- (void)startCountingDown
{
    if (self.currentState != VertifyButtonStateSending) {
        return;
    }
    self.currentState = VertifyButtonStateCountDown;
}

- (void)send
{
    if (self.currentState != VertifyButtonStateStandBy) {
        return;
    }
    self.currentState = VertifyButtonStateSending;
}

- (void)restart
{
    self.currentState = VertifyButtonStateStandBy;
}

- (void)clickEventHandler:(UIButton *)button
{
    [self send];
}

- (void)countDownToResend:(NSTimer *)timer
{
    if (_countDown > 1) {
        _countDown -- ;
        [self setTitle:[NSString stringWithFormat:stateCountDownDesc, _countDown] forState:UIControlStateDisabled];
    } else {
        self.currentState = VertifyButtonStateStandBy;
    }
}

- (NSTimer *)makeNewResendTimer
{
    return [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownToResend:) userInfo:nil repeats:YES];
}

- (void)willTransformFromState:(VertifyButtonState)previousState ToState:(VertifyButtonState)currentState
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(verfityButton:willTransformFromState:toState:)]) {
        [self.delegate verfityButton:self willTransformFromState:_previousState toState:currentState];
    }
}

- (void)didTransformFromState:(VertifyButtonState)previousState ToState:(VertifyButtonState)currentState
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(verfityButton:didTransformFromState:toState:)]) {
        [self.delegate verfityButton:self didTransformFromState:_previousState toState:currentState];
    }
}
@end
