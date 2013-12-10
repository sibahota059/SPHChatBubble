//
//  SPHAppDelegate.h
//  SPHChatBubble
//
//  Created by Siba Prasad Hota  on 10/18/13.
//  Copyright (c) 2013 Wemakeappz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPHViewController;

@interface SPHAppDelegate : UIResponder <UIApplicationDelegate>
{
    id currentViewController;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SPHViewController *viewController;

@property (nonatomic, assign) id currentViewController;

@end
