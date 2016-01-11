//
//  CustomButton.m
//  MyButton
//
//  Created by Zin_戦 on 16/1/11.
//  Copyright © 2016年 Zin戦壕. All rights reserved.
//

#import "CustomButton.h"
#define btnFrameWidth self.frame.size.width
#define btnFrameHeight self.frame.size.height
#define EveryHeight btnFrameHeight/3

static const CGFloat kDefaulIconSize = 15.0;
static const CGFloat kDefaultMarginWidth = 5.0;
static NSString *const kGeneratedIconName = @"Generated Icon";

@interface CustomButton()
@property BOOL isChaining;

@end
@implementation CustomButton

- (void)setOtherButtons:(NSArray *)otherButtons {
    if (!self.isChaining) {
        _otherButtons = otherButtons;
        self.isChaining = YES;
        for (CustomButton *radioButton in self.otherButtons) {
            NSMutableArray *otherButtons = [[NSMutableArray alloc] initWithArray:self.otherButtons];
            [otherButtons addObject:self];
            [otherButtons removeObject:radioButton];
            [radioButton setOtherButtons:[otherButtons copy]];
        }
        self.isChaining = NO;
    }
}

//- (void)setIcon:(UIImage *)icon {
//    _icon = icon;
//    [self setImage:self.icon forState:UIControlStateNormal];
//
//}

- (void)setIconSelected:(UIImage *)iconSelected {
    _iconSelected = iconSelected;
    [self setBackgroundColor:[UIColor blueColor]];
//        [self setImage:self.iconSelected forState:UIControlStateSelected];
//        [self setImage:self.iconSelected forState:UIControlStateSelected | UIControlStateHighlighted];
    
}

- (void)setMultipleSelectionEnabled:(BOOL)multipleSelectionEnabled {
    if (!self.isChaining) {
        self.isChaining = YES;
        _multipleSelectionEnabled = multipleSelectionEnabled;
        
        for (CustomButton *radioButton in self.otherButtons) {
            radioButton.multipleSelectionEnabled = multipleSelectionEnabled;
        }
        self.isChaining = NO;
    }
}

#pragma mark - Helpers

- (void)drawButton {
    if (!self.icon || [self.icon.accessibilityIdentifier isEqualToString:kGeneratedIconName]) {
        self.icon = [self drawIconWithSelection:NO];
    }
    if (!self.iconSelected || [self.iconSelected.accessibilityIdentifier isEqualToString:kGeneratedIconName]) {
        self.iconSelected = [self drawIconWithSelection:YES];
    }
    CGFloat marginWidth = self.marginWidth ? self.marginWidth : kDefaultMarginWidth;
    if (self.isIconOnRight) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0, self.frame.size.width - self.icon.size.width, 0, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.icon.size.width, 0, marginWidth + self.icon.size.width);
    } else {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, marginWidth, 0, 0);
    }
}

- (UIImage *)drawIconWithSelection:(BOOL)selected {
    UIColor *defaulColor = selected ? [self titleColorForState:UIControlStateSelected | UIControlStateHighlighted] : [self titleColorForState:UIControlStateNormal];
    UIColor *iconColor = self.iconColor ? self.iconColor : defaulColor;
    UIColor *indicatorColor = self.indicatorColor ? self.indicatorColor : defaulColor;
    CGFloat iconSize = self.iconSize ? self.iconSize : kDefaulIconSize;
    CGFloat iconStrokeWidth = self.iconStrokeWidth ? self.iconStrokeWidth : iconSize / 9;
    CGFloat indicatorSize = self.indicatorSize ? self.indicatorSize : iconSize * 0.5;
    
    CGRect rect = CGRectMake(0, 0, iconSize, iconSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    // draw icon
    UIBezierPath* iconPath;
    CGRect iconRect = CGRectMake(iconStrokeWidth / 2, iconStrokeWidth / 2, iconSize - iconStrokeWidth, iconSize - iconStrokeWidth);
    if (self.isIconSquare) {
        iconPath = [UIBezierPath bezierPathWithRect:iconRect];
    } else {
        iconPath = [UIBezierPath bezierPathWithOvalInRect:iconRect];
    }
    [iconColor setStroke];
    iconPath.lineWidth = iconStrokeWidth;
    [iconPath stroke];
    CGContextAddPath(context, iconPath.CGPath);
    
    // draw indicator
    if (selected) {
        UIBezierPath* indicatorPath;
        CGRect indicatorRect = CGRectMake((iconSize - indicatorSize) / 2, (iconSize - indicatorSize) / 2, indicatorSize, indicatorSize);
        if (self.isIconSquare) {
            indicatorPath = [UIBezierPath bezierPathWithRect:indicatorRect];
        } else {
            indicatorPath = [UIBezierPath bezierPathWithOvalInRect:indicatorRect];
        }
        [indicatorColor setFill];
        [indicatorPath fill];
        CGContextAddPath(context, indicatorPath.CGPath);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsPopContext();
    UIGraphicsEndImageContext();
    
    image.accessibilityIdentifier = kGeneratedIconName;
    return image;
}

- (void)touchDown {
    [self setSelected:YES];
}

- (void)initRadioButton {
    [super addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchUpInside];
}

- (void)prepareForInterfaceBuilder {
    [self initRadioButton];
    [self drawButton];
}

#pragma mark - DLRadiobutton

- (void)deselectOtherButtons {
    for (UIButton *button in self.otherButtons) {
        [button setSelected:NO];
        button.backgroundColor = [UIColor whiteColor];
    }
}

- (CustomButton *)selectedButton {
    if (!self.isMultipleSelectionEnabled) {
        if (self.selected) {
            return self;
        } else {
            for (CustomButton *radioButton in self.otherButtons) {
                if (radioButton.selected) {
                    return radioButton;
                }
            }
        }
    }
    return nil;
}

- (NSArray *)selectedButtons {
    NSMutableArray *selectedButtons = [[NSMutableArray alloc] init];
    if (self.selected) {
        [selectedButtons addObject:self];
    }
    for (CustomButton *radioButton in self.otherButtons) {
        if (radioButton.selected) {
            [selectedButtons addObject:radioButton];
        }
    }
    return selectedButtons;
}

#pragma mark - UIButton

- (UIColor *)titleColorForState:(UIControlState)state {
    UIColor *normalColor = [super titleColorForState:UIControlStateNormal];
    if (state == (UIControlStateSelected | UIControlStateHighlighted)) {
        UIColor *selectedOrHighlightedColor = [super titleColorForState:UIControlStateSelected | UIControlStateHighlighted];
        if (selectedOrHighlightedColor == normalColor || selectedOrHighlightedColor == nil) {
            selectedOrHighlightedColor = [super titleColorForState:UIControlStateSelected];
        }
        if (selectedOrHighlightedColor == normalColor || selectedOrHighlightedColor == nil) {
            selectedOrHighlightedColor = [super titleColorForState:UIControlStateHighlighted];
        }
        [self setTitleColor:selectedOrHighlightedColor forState:UIControlStateSelected | UIControlStateHighlighted];
    }
    
    return [super titleColorForState:state];
}

#pragma mark - UIControl

- (void)setSelected:(BOOL)selected {
    if (self.isMultipleSelectionEnabled) {
        [super setSelected:!self.isSelected];
    } else {
        [super setSelected:selected];
        if (selected) {
            [self deselectOtherButtons];
        }
    }
}

#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initRadioButton];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initRadioButton];
        _lab1 = [[UILabel alloc] init];

        _lab1.text = @"lab1";
        _lab1.font = [UIFont systemFontOfSize:14];
        _lab1.textColor = [UIColor redColor];
        _lab1.textAlignment = NSTextAlignmentCenter;
        _lab1.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_lab1];
        
        _lab2 = [[UILabel alloc] init];

        _lab2.font = [UIFont systemFontOfSize:10];
        _lab2.text = @"lab2";
        _lab2.textColor = [UIColor redColor];
        
        _lab2.textAlignment = NSTextAlignmentCenter;
        _lab2.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_lab2];
        
        _lab3 = [[UILabel alloc] init];

        _lab3.text = @"￥1230.0";
        _lab3.font = [UIFont systemFontOfSize:10];
        _lab3.textColor = [UIColor redColor];
        
        _lab3.textAlignment = NSTextAlignmentCenter;
        _lab3.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_lab3];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _lab1.frame = CGRectMake(0, 0,  btnFrameWidth, EveryHeight);
    _lab2.frame = CGRectMake(0, EveryHeight, btnFrameWidth, EveryHeight);
    _lab3.frame = CGRectMake(0, EveryHeight*2, btnFrameWidth, EveryHeight);
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawButton];
}
@end
