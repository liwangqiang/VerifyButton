//
//  VertifyButton.h
//  VertifyButton
//
//  Created by 李王强 on 15/10/24.
//  Copyright © 2015年 personal. All rights reserved.
//  状态机概念

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VertifyButtonState) {
    VertifyButtonStateStandBy,
    VertifyButtonStateSending,
    VertifyButtonStateCountDown
};


@class VertifyButton;
@protocol VertifyButtonDelegate <NSObject>

@optional
- (void)verfityButton:(VertifyButton *)vertifyButton
            willTransformFromState:(VertifyButtonState)previousState
              toState:(VertifyButtonState)currentState;


- (void)verfityButton:(VertifyButton *)vertifyButton
didTransformFromState:(VertifyButtonState)previousState
              toState:(VertifyButtonState)currentState;

@end


@interface VertifyButton : UIButton

@property (assign, nonatomic, readonly) VertifyButtonState currentState;
@property (weak, nonatomic) id<VertifyButtonDelegate> delegate;

- (void)restart;
- (void)send;
- (void)startCountingDown;

@end
