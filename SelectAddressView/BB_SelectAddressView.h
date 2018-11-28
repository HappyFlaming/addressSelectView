//
//  BB_SelectAddressView.h
//  AddressSelect
//
//  Created by gyx on 2018/11/26.
//  Copyright © 2018 Bear. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BB_SelectAddressView : UIView

@property (nonatomic,copy) void (^addressBlock)(NSString *address);
/**
 显示view
 */
- (void)showView;

@end

NS_ASSUME_NONNULL_END
