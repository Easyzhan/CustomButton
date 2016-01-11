//
//  ViewController.m
//  MyButton
//
//  Created by Zin_戦 on 16/1/11.
//  Copyright © 2016年 Zin戦壕. All rights reserved.
//

#import "ViewController.h"
#import "CustomButton.h"

#define superView self.view.frame.size.width
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomButton *firstTypeButton = [[CustomButton alloc] initWithFrame:CGRectMake(0, 50, superView/5, 60)];
     firstTypeButton.layer.cornerRadius = 15;
    // 圆角
    firstTypeButton.layer.masksToBounds = YES;
    firstTypeButton.layer.cornerRadius = 6.0;
    firstTypeButton.layer.borderWidth = 1.0;
    
    [firstTypeButton addTarget:self action:@selector(logSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstTypeButton];
    
    
    
    // other buttons

    NSMutableArray *otherTypeButtons = [NSMutableArray new];

    for (NSInteger btnNum =1; btnNum<5; btnNum++){
        // customize button
        CustomButton *typeButton = [[CustomButton alloc] initWithFrame:CGRectMake(btnNum*superView/5, 50, superView/5, 60)];
        // 圆角
        typeButton.layer.masksToBounds = YES;
        typeButton.layer.cornerRadius = 6.0;
        typeButton.layer.borderWidth = 1.0;
     
        typeButton.lab1.text = [NSString stringWithFormat:@"test-%d",btnNum ];

        [otherTypeButtons addObject:typeButton];
        [typeButton addTarget:self action:@selector(logSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:typeButton];
    }
    
    firstTypeButton.otherButtons = otherTypeButtons;
}

- (void)logSelectedButton:(CustomButton *)radiobutton {
    if (radiobutton.isMultipleSelectionEnabled) {
        for (CustomButton *button in radiobutton.selectedButtons) {

            NSLog(@"%@ is selected.\n", button.lab2.text);
        }
    } else {
        NSLog(@"%@ ======0-0-=0is selected.\n", radiobutton.selectedButton.lab3.text);

    }
}
@end
