//
//  ViewController.m
//  ISEmojiViewSample
//
//  Created by isaced on 14/12/25.
//  Copyright (c) 2014年 isaced. All rights reserved.
//

#import "ViewController.h"
#import "ISEmojiView.h"

@interface ViewController () <ISEmojiViewDelegate>

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     // Init ISEmojiView
     */
    ISEmojiView *emojiView = [ISEmojiView new];
    emojiView.delegate = self;
    self.textView.inputView = emojiView;

    [self.textView becomeFirstResponder];
}

#pragma mark - ISEmojiViewDelegate

- (void)emojiView:(ISEmojiView *)emojiView didSelectEmoji:(NSString *)emoji {
    [self.textView insertText:emoji];
}

- (void)emojiView:(ISEmojiView *)emojiView didPressDeleteButton:(UIButton *)deletebutton {
    [self.textView deleteBackward];
}

@end
