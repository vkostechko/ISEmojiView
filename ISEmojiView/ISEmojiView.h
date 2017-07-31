//
//  ISEmojiView.h
//  ISEmojiViewSample
//
//  Created by isaced on 14/12/25.
//  Copyright (c) 2014 Year isaced. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  The custom keyboard view
 */
@class ISEmojiView;

/*
 // emoji view action callback delegate
 */
@protocol ISEmojiViewDelegate <NSObject>

/*
 // did press a emoji button
 // - Parameters:
 //     - emojiView: the emoji view
 //     - emoji: a emoji
 */
- (void)emojiView:(nonnull ISEmojiView *)emojiView didSelectEmoji:(nonnull NSString *)emoji;

/*
 // will delete last character in you input view
 // - Parameter emojiView: the emoji view
 */
- (void)emojiView:(nonnull ISEmojiView *)emojiView didPressDeleteButton:(nonnull UIButton *)deleteButton;

@end

@interface ISEmojiView : UIView

/*
 // the delegate for callback
 */
@property (nonatomic, weak, nullable) id<ISEmojiViewDelegate> delegate;

/*
 // long press to pop preview effect like iOS10 system emoji keyboard, Default is true
 */
@property (nonatomic, assign) BOOL isShowPopPreview;

/**
 *  All emoji characters
 */
@property (nonatomic, strong, nonnull) NSArray <NSArray<NSString *> *>* emojis;

- (nullable instancetype)initWithEmojies:(nonnull NSArray <NSArray<NSString *> *> *)emojis;

@end
