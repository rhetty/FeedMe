//
//  JWComboBox.h
//  JWComboBox
//
//  Created by 黄嘉伟 on 2017/2/23.
//  Copyright © 2017年 huangjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JWComboBox;

@protocol JWComboBoxDataSource
@required
- (NSUInteger)numberOfOptionsInComboBox:(JWComboBox *)comboBox;
- (NSString *)comboBox:(JWComboBox *)comboBox contentAt:(NSUInteger)index;
@optional
- (NSString *)titleForComboBox:(JWComboBox *)comboBox;
@end

@protocol JWComboBoxDelegate <NSObject>
@optional
- (void)comboBox:(JWComboBox *)comboBox didSelectAt:(NSUInteger)index;
@end

@interface JWComboBox : UIView
@property (weak, nonatomic) id<JWComboBoxDataSource> dataSource;
@property (weak, nonatomic) id<JWComboBoxDelegate> delegate;
@property (nonatomic, strong) UIColor *contentLabelColor UI_APPEARANCE_SELECTOR;
- (void)reloadData;
@end
