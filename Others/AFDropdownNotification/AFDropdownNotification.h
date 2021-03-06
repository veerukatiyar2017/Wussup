//
//  AFDropdownNotification.h
//  AFDropdownNotification-Demo
//
//  Created by Alvaro Franco on 21/08/14.
//  Copyright (c) 2014 AluanaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol AFDropdownNotificationDelegate <NSObject>

@optional

-(void)dropdownNotificationTopButtonTapped;
-(void)dropdownNotificationBottomButtonTapped;
-(void)dropdownNotificationViewTapped;

@end

@interface AFDropdownNotification : NSObject

typedef NS_ENUM(NSInteger, AFDropdownNotificationEvent) {
    
    AFDropdownNotificationEventTopButton,
    AFDropdownNotificationEventBottomButton,
    AFDropdownNotificationEventTap
};

typedef void (^block)(AFDropdownNotificationEvent event);

@property (nonatomic, strong) id<AFDropdownNotificationDelegate> notificationDelegate;

@property (nonatomic, strong) UIView *notificationView;

@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *subtitleText;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSString *topButtonText;
@property (nonatomic, strong) NSString *bottomButtonText;

@property (nonatomic, strong)IBOutlet UIButton *btnTap;

@property (nonatomic) BOOL isBeingShown;
@property (nonatomic,strong)NSLayoutConstraint *imvWidth;

-(void)listenEventsWithBlock:(block)block;

-(void)presentInView:(UIView *)view withGravityAnimation:(BOOL)animation;
-(void)dismissWithGravityAnimation:(BOOL)animation;

@property (nonatomic) BOOL dismissOnTap;

@end
