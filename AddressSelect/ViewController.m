//
//  ViewController.m
//  AddressSelect
//
//  Created by gyx on 2018/11/23.
//  Copyright © 2018 Bear. All rights reserved.
//

#import "ViewController.h"
#import "BB_SelectAddressView.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *showAddressLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)selectClick:(UIButton *)sender {
    BB_SelectAddressView *view = [[BB_SelectAddressView alloc] init];
    __block typeof(self) mySelf = self;
    view.addressBlock = ^(NSString * _Nonnull address) {
        mySelf.showAddressLabel.text = address;
    };
    [view showView];
}

@end
