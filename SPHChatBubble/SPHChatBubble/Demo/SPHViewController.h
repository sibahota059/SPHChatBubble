//
//  SPHViewController.h
//  SPHChatBubble
//
//  Created by Siba Prasad Hota  on 10/18/13.
//  Copyright (c) 2013 Wemakeappz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "MNMPullToRefreshManager.h"

@class QBPopupMenu;

@interface SPHViewController : UIViewController<HPGrowingTextViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MNMPullToRefreshManagerClient>
{
     NSMutableArray *sphBubbledata;
     UIView *containerView;
     HPGrowingTextView *textView;
     int selectedRow;
     BOOL newMedia;
}
@property (nonatomic, readwrite, assign) NSUInteger reloads;
@property (nonatomic, readwrite, strong) MNMPullToRefreshManager *pullToRefreshManager;

@property (weak, nonatomic) IBOutlet UIImageView *Uploadedimage;
@property (nonatomic, strong) QBPopupMenu *popupMenu;
@property (weak, nonatomic) IBOutlet UITableView *sphChatTable;
@property (nonatomic, retain) UIImagePickerController *imgPicker;

- (IBAction)endViewedit:(id)sender;

- (void) handleURL:(NSURL *)url;

@end
