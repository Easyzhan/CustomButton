//
//  CustomButton.h
//  MyButton
//
//  Created by Zin_戦 on 16/1/11.
//  Copyright © 2016年 Zin戦壕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton
/**
 Container for holding other buttons in same group.
 */
@property (nonatomic,strong) NSArray *otherButtons;
/**
 Size of icon, default is kDefaulIconSize.
 */
@property (nonatomic) IBInspectable CGFloat iconSize;

/**
 Color of icon, default is title color for current UIControlState.
 */
@property (nonatomic) IBInspectable UIColor *iconColor;

/**
 Stroke width of icon, default is iconSize / 9.
 */
@property (nonatomic) IBInspectable CGFloat iconStrokeWidth;

/**
 Size of selection indicator, default is iconSize * 0.5.
 */
@property (nonatomic) IBInspectable CGFloat indicatorSize;

/**
 Color of selection indicator, default is title color for current UIControlState.
 */
@property (nonatomic) IBInspectable UIColor *indicatorColor;

/**
 Margin width between icon and title, default is kDefaultMarginWidth.
 */
@property (nonatomic) IBInspectable CGFloat marginWidth;

/**
 Whether icon on the right side, default is NO.
 */
@property (nonatomic, getter=isIconOnRight) IBInspectable BOOL iconOnRight;

/**
 Whether use square icon, default is NO.
 */
@property (nonatomic, getter=isIconSquare) IBInspectable BOOL iconSquare;

/**
 Image for radio button icon (optional).
 */
@property (nonatomic) IBInspectable UIImage *icon;

/**
 Image for radio button icon when selected (optional).
 */
@property (nonatomic) IBInspectable UIImage *iconSelected;

/**
 Whether enable multiple selection, default is NO.
 */
@property (nonatomic, getter=isMultipleSelectionEnabled) BOOL multipleSelectionEnabled;
/**
 *  lab1
 */
@property (nonatomic,strong) UILabel *lab1;
/**
 *  lab2
 */
@property (nonatomic,strong) UILabel *lab2;
/**
 *  lab3
 */
@property (nonatomic,strong) UILabel *lab3;
/**
 @return Selected button in same group.
 */
- (CustomButton *)selectedButton;

/**
 @return Selected buttons in same group, use it only if multiple selection is enabled.
 */
- (NSArray *)selectedButtons;

/**
 Clears selection for other buttons in in same group.
 */
- (void)deselectOtherButtons;
@end
