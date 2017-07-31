//
//  ISEmojiView.m
//  ISEmojiViewSample
//
//  Created by isaced on 14/12/25.
//  Copyright (c) 2014 Year isaced. All rights reserved.
//

#import "ISEmojiView.h"

#define EMOJI_SIZE CGSizeMake(45.f, 35.f)
#define EMOJI_FONT_SIZE 30.f
#define COLLECTION_INSET UIEdgeInsetsMake(10.f, 10.f, 38.f, 10.f)
#define COLLECTION_MIN_LINE_SPACING 0.f
#define COLLECTION_MIN_INTERITEM_SPACING 0.f
#define IS_MAIN_BACKGROUND_COLOR [UIColor colorWithRed:249.f/255.f green:249.f/255.f blue:249.f/255.f alpha:1.f]
#define TOP_PART_SIZE CGSizeMake(EMOJI_SIZE.width * 1.3, EMOJI_SIZE.height * 1.6)
#define BOTTOM_PART_SIZE CGSizeMake(EMOJI_SIZE.width * 0.8, EMOJI_SIZE.height + 10)

#define EMOJI_POP_VIEW_SIZE CGSizeMake(TOP_PART_SIZE.width,TOP_PART_SIZE.height + BOTTOM_PART_SIZE.height)
#define POP_BACKGROUND_COLOR [UIColor whiteColor]

#define SECTIONS @[@"People", @"Nature", @"Objects", @"Places", @"Symbols"]

/// the emoji cell in the grid

@interface ISEmojiCell : UICollectionViewCell {
    UILabel* emojiLabel;
}

@property (nonatomic, strong, readonly, nullable) NSString* emoji;

@end

@implementation ISEmojiCell

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - Public

- (void)setEmoji:(NSString *)emoji {
    emojiLabel.text = emoji;
}

#pragma mark - Private

- (void)setupUI {
    emojiLabel = [self emojiLabel];
    emojiLabel.frame = self.bounds;
    [self addSubview:emojiLabel];
}

- (UILabel*)emojiLabel {
    UILabel* label = [UILabel new];
    label.font = [UIFont fontWithName:@"Apple color emoji" size: EMOJI_FONT_SIZE];
    label.textAlignment = NSTextAlignmentCenter;
    label.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    return label;
}

@end




@interface ISEmojiPopView : UIView {
    UILabel* emojiLabel;
}

- (void)setEmoji:(NSString*)emoji;
- (void)move:(CGPoint)location animated:(BOOL)animated;
- (void)dismiss;

@end


@implementation ISEmojiPopView

#pragma marl - Init

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, EMOJI_POP_VIEW_SIZE.width, EMOJI_POP_VIEW_SIZE.height)];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - Public

- (void)move:(CGPoint)location animated:(BOOL)animated {
    [UIView animateWithDuration:(animated ? 0.08f : 0.f) animations:^{
        self.alpha = 1.f;
        self.frame = CGRectMake(location.x, location.y, self.frame.size.width, self.frame.size.height);
    }completion:^(BOOL finished) {
        self.hidden = NO;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.08f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)setEmoji:(NSString*)emoji {
    self.emojiLabel.text = emoji;
}


#pragma mark - Private

- (void)setupUI {
    
    // path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRoundedRect(path, nil, CGRectMake(0.f, 0.f, TOP_PART_SIZE.width, TOP_PART_SIZE.height), 10.f, 10.f);
    CGPathAddRoundedRect(path, nil, CGRectMake(TOP_PART_SIZE.width / 2.f - BOTTOM_PART_SIZE.width / 2.0, TOP_PART_SIZE.height - 10.f, BOTTOM_PART_SIZE.width, BOTTOM_PART_SIZE.height + 10.f), 5.f, 5.f);
    
    // border
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.path = path;
    borderLayer.strokeColor = [UIColor colorWithWhite: 0.8f alpha: 1.f].CGColor; //UIColor.red.cgColor
    borderLayer.lineWidth = 1.f;
    [self.layer addSublayer:borderLayer];
    
    // mask
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    maskLayer.path = path;
    
    // content layer
    CALayer* contentLayer = [CALayer layer];
    contentLayer.frame = self.bounds;
    contentLayer.backgroundColor = POP_BACKGROUND_COLOR.CGColor;
    contentLayer.mask = maskLayer;
    
    [self.layer addSublayer:contentLayer];
    
    // add label
    emojiLabel = [self emojiLabel];
    emojiLabel.frame = CGRectMake(0.f, 0.f, self.bounds.size.width, TOP_PART_SIZE.height);
    [self addSubview:emojiLabel];
    
    self.userInteractionEnabled = NO;
    self.hidden = YES;
}

- (UILabel*)emojiLabel {
    UILabel* label = [UILabel new];
    label.font = [UIFont fontWithName:@"Apple color emoji" size: EMOJI_FONT_SIZE];
    label.textAlignment = NSTextAlignmentCenter;
    label.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    return label;
}

@end






@interface ISEmojiView () <UICollectionViewDelegate, UICollectionViewDataSource> {
    UICollectionView* collectionView;
    UIPageControl* pageControl;
    UIButton* deleteButton;
}

@property (nonatomic, strong) ISEmojiPopView *emojiPopView;

+ (NSString *)pathOfResourceInBundle:(NSString *)fileName andFileType:(NSString *)fileType;

@end

@implementation ISEmojiView

#pragma mark - Init

- (instancetype)initWithEmojies:(NSArray<NSString *> *)emojis {
    self = [super init];
    if (self) {
        _isShowPopPreview = YES;
        _emojis = [emojis copy];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isShowPopPreview = YES;
        [self setupUI];
    }
    return self;
}

- (void)setEmojiBackgroundColor:(UIColor *)emojiBackgroundColor {
    _emojiBackgroundColor = emojiBackgroundColor;
    collectionView.backgroundColor = emojiBackgroundColor;
}

#pragma mark - Private


- (UICollectionView *)collectionView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = EMOJI_SIZE;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = COLLECTION_MIN_LINE_SPACING;
    layout.minimumInteritemSpacing = COLLECTION_MIN_INTERITEM_SPACING;
    layout.sectionInset = COLLECTION_INSET;
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collection.showsHorizontalScrollIndicator = NO;
    collection.showsVerticalScrollIndicator = NO;
    collection.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    collection.backgroundColor = self.emojiBackgroundColor ?: IS_MAIN_BACKGROUND_COLOR;
    [collection registerClass:[ISEmojiCell class] forCellWithReuseIdentifier:@"cell"];
    return collection;
}


- (UIPageControl *)pageControl {
    UIPageControl *pageContr = [UIPageControl new];
    pageContr.hidesForSinglePage = YES;
    pageContr.currentPage = 0;
    pageContr.backgroundColor = [UIColor clearColor];
    return pageContr;
}

- (UIButton *)deleteButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"⌫" forState:UIControlStateNormal];
    button.tintColor = [UIColor lightGrayColor];
    return button;
}

- (ISEmojiPopView *)emojiPopView {
    if (!_emojiPopView) {
        _emojiPopView = [ISEmojiPopView new];
    }
    return _emojiPopView;
}

- (NSArray <NSArray<NSString *> *>*)emojis {
    if (!_emojis) {
        _emojis = [[self defaultEmojis] copy];
    }
    return _emojis;
}


- (CGRect)defaultFrame {
    return CGRectMake(0.f, 0.f, UIScreen.mainScreen.bounds.size.width, 236.f);
}

- (void)setupUI {
    self.frame = [self defaultFrame];
    
    // ScrollView
    collectionView = [self collectionView];
    collectionView.frame = self.bounds;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self addSubview:collectionView];
    [collectionView reloadData];
    
    // PageControl
    pageControl = [self pageControl];
    [pageControl addTarget:self action:@selector(pageControlTouched:) forControlEvents:UIControlEventTouchUpInside];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.f];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:153.f/255.f green: 153.f/255.f blue: 153.f/255.f alpha: 1];
    pageControl.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
    [self addSubview:pageControl];
    
    // DeleteButton
    deleteButton = [self deleteButton];
    [deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    
    // Long press to pop preview
    UILongPressGestureRecognizer* emojiLongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(emojiLongPressHandle:)];
    [self addGestureRecognizer:emojiLongPressGestureRecognizer];
    
    [self addSubview:_emojiPopView];
}

- (void)updateControlLayout {
    self.frame = [self defaultFrame];
    
    // update page control
    NSUInteger pageCount = collectionView.numberOfSections;
    CGSize pageControlSizes = [pageControl sizeForNumberOfPages:pageCount];
    pageControl.frame = CGRectMake(CGRectGetMidX(self.frame) - pageControlSizes.width / 2.0,
                                   self.frame.size.height - pageControlSizes.height,
                                   pageControlSizes.width,
                                   pageControlSizes.height);
    pageControl.numberOfPages = pageCount;
    
    // update delete button
    deleteButton.frame = CGRectMake(self.frame.size.width - 48.f, self.frame.size.height - 40.f, 40.f, 40.f);
}

- (void)layoutSubviews {
    [self updateControlLayout];
}

- (NSArray<NSString*>*)defaultEmojis {
//    NSString * filePath = [ISEmojiView pathOfResourceInBundle:@"ISEmojiList" andFileType:@"plist"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ISEmojiList" ofType:@"plist"];
    NSDictionary* sections = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSMutableArray* emojiList = [NSMutableArray new];
    for (NSString* sectionName in SECTIONS) {
        NSArray* emojis = sections[sectionName];
        if (emojis) {
            [emojiList addObject:emojis];
        }
    }
    return [emojiList mutableCopy];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.emojis.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray* emojiesInSection = self.emojis[section];
    return emojiesInSection.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView_ cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ISEmojiCell * cell = [collectionView_ dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setEmoji:self.emojis[indexPath.section][indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString* emoji = self.emojis[indexPath.section][indexPath.row];
    [self.delegate emojiView:self didSelectEmoji:emoji];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UICollectionViewCell* firstVisibleCell = collectionView.visibleCells.firstObject;
    if (firstVisibleCell) {
        NSIndexPath* indexPath = [collectionView indexPathForCell:firstVisibleCell];
        pageControl.currentPage = indexPath.section;
    }
}

//MARK: LongPress

- (BOOL)longPressLocationInEdge:(CGPoint)location {
    CGRect edgeRect = UIEdgeInsetsInsetRect(collectionView.bounds, COLLECTION_INSET);
    return CGRectContainsPoint(edgeRect, location);
}

- (void)emojiLongPressHandle:(UILongPressGestureRecognizer *)sender {
    if (!self.isShowPopPreview) {
        return;
    }
    
    CGPoint location = [sender locationInView:collectionView];
    
    if ([self longPressLocationInEdge:location]) {
        NSIndexPath* indexPath = [collectionView indexPathForItemAtPoint:location];
        UICollectionViewLayoutAttributes *attr = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
        if (attr) {
            NSString* emoji = self.emojis[indexPath.section][indexPath.row];
            if (sender.state == UIGestureRecognizerStateEnded) {
                [_emojiPopView dismiss];
                [self.delegate emojiView:self didSelectEmoji:emoji];
            }else{
                CGRect cellRect = attr.frame;
                CGRect cellFrameInSuperView = [collectionView convertRect:cellRect toView:self];
                [_emojiPopView setEmoji:emoji];
                CGPoint emojiPopLocaltion = CGPointMake(cellFrameInSuperView.origin.x - ((TOP_PART_SIZE.width - BOTTOM_PART_SIZE.width) / 2.0) + 5.f,
                                                        cellFrameInSuperView.origin.y - TOP_PART_SIZE.height - 10.f);
                [_emojiPopView move: emojiPopLocaltion animated: sender.state != UITouchPhaseBegan];
            }
        }else{
            [_emojiPopView dismiss];
        }
    }else{
        [_emojiPopView dismiss];
    }
}

#pragma mark - Actions

- (void)emojiButtonPressed:(UIButton* )sender {
    NSString* emoji = sender.titleLabel.text;
    [self.delegate emojiView:self didSelectEmoji:emoji];
}

- (void)deleteButtonPressed:(UIButton *)sender {
    [self.delegate emojiView:self didPressDeleteButton:sender];
}

- (void)pageControlTouched:(UIPageControl *)sender {
    CGRect bounds = collectionView.bounds;
    bounds.origin.x = bounds.size.width * sender.currentPage;
    [collectionView scrollRectToVisible:bounds animated:YES];
}

//MARK: Tools

+ (NSBundle *)thisBundle {
    NSBundle* podBundle = [NSBundle bundleForClass:[ISEmojiView class]];
    NSURL* bundleURL = [podBundle URLForResource:@"ISEmojiView" withExtension:@"bundle"];
    if (bundleURL) {
        return [NSBundle bundleWithURL:bundleURL];
    }
    
    return [NSBundle new];
}

+ (NSString *)pathOfResourceInBundle:(NSString *)fileName andFileType:(NSString *)fileType {
    NSString* filePath = [[self thisBundle] pathForResource:fileName ofType:fileType];
    return filePath;
}

@end
