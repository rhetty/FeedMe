//
//  JWComboBox.m
//  JWComboBox
//
//  Created by 黄嘉伟 on 2017/2/23.
//  Copyright © 2017年 huangjw. All rights reserved.
//

#import "JWComboBox.h"

#define ROW_HEIGHT 44
#define MAX_TABLE_HEIGHT 264
#define SELECTED_TEXT_COLOR [self tintColor]
#define COMMON_TEXT_COLOR [UIColor darkGrayColor]

#define TABLE_BORDER_WIDTH 0.5
#define TABLE_BORDER_COLOR [UIColor colorWithRed:198/255.0 green:198/255.0 blue:202/255.0 alpha:1]

@interface JWComboBox() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *selectTableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIButton *maskView;
//@property (nonatomic, assign, getter=isDown) BOOL down;
//@property (nonatomic, assign) CGRect rectInTop;

@property (nonatomic, assign) NSUInteger numberOfOptions;
@property (nonatomic, strong) NSString *title;
@end

@implementation JWComboBox

#pragma mark - Public

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self initialize];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}

- (void)reloadData
{
  self.numberOfOptions = [self.dataSource numberOfOptionsInComboBox:self];
//  self.title = [self.dataSource titleForComboBox:self];
  [self updateContent:[self.dataSource comboBox:self contentAt:0]];
  [self.selectTableView reloadData];
}

#pragma mark - Lifecycles

- (void)layoutSubviews
{
  [super layoutSubviews];
  // adjust table view's frame
  CGRect boxRectInTop = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
  self.selectTableView.frame = CGRectMake(boxRectInTop.origin.x, boxRectInTop.origin.y + self.frame.size.height, self.frame.size.width, MAX_TABLE_HEIGHT);
}

#pragma mark - Properties

- (void)setDataSource:(id<JWComboBoxDataSource>)dataSource
{
  _dataSource = dataSource;
  [self reloadData];
}

- (void)setContentLabelColor:(UIColor *)contentLabelColor
{
  self.contentLabel.textColor = contentLabelColor;
}

static NSString *const kCellIdentifier = @"Cell";
- (UITableView *)selectTableView
{
  if (!_selectTableView) {
    _selectTableView = [[UITableView alloc] init];
    _selectTableView.dataSource = self;
    _selectTableView.delegate = self;
    _selectTableView.hidden = YES;
    _selectTableView.layer.borderWidth = TABLE_BORDER_WIDTH;
    _selectTableView.layer.borderColor = [TABLE_BORDER_COLOR CGColor];
    [_selectTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    _selectTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _selectTableView.rowHeight = ROW_HEIGHT;
    [_selectTableView setSeparatorInset:UIEdgeInsetsZero];
  }
  return _selectTableView;
}

- (UIButton *)maskView
{
  if (!_maskView) {
    _maskView = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_maskView addTarget:self action:@selector(maskViewPressed) forControlEvents:UIControlEventTouchUpInside];
  }
  return _maskView;
}

- (UILabel *)contentLabel
{
  if (!_contentLabel) {
    _contentLabel = [[UILabel alloc] initWithFrame:self.frame];
    _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.font = [UIFont systemFontOfSize:17];
  }
  return _contentLabel;
}

#pragma mark - Private

- (void)initialize
{
  [self addSubview:self.contentLabel];
  
  UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressed)];
  [self addGestureRecognizer:tap];
}

- (void)pressed
{
  [self toggleTableView];
}

- (void)maskViewPressed
{
  [self toggleTableView];
}

- (void)toggleTableView
{
  self.selectTableView.hidden = !self.selectTableView.hidden;
  if (self.selectTableView.hidden) {
    [self.maskView removeFromSuperview];
  } else {
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectTableView];
  }
}

- (void)updateContent:(NSString *)content
{
  self.contentLabel.text = [NSString stringWithFormat:@"%@ ▾", content];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.numberOfOptions;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.textLabel.text = [self.dataSource comboBox:self contentAt:indexPath.row];
  cell.textLabel.font = [UIFont systemFontOfSize:13.0];
  cell.textLabel.textAlignment = NSTextAlignmentCenter;
  cell.textLabel.textColor = indexPath.row == self.selectedIndex ? SELECTED_TEXT_COLOR : COMMON_TEXT_COLOR;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self toggleTableView];
  self.selectedIndex = indexPath.row;
  [self updateContent:[self.dataSource comboBox:self contentAt:indexPath.row]];
  [self.selectTableView reloadData];
  if ([self.delegate respondsToSelector:@selector(comboBox:didSelectAt:)]) {
    [self.delegate comboBox:self didSelectAt:indexPath.row];
  }
}

@end
