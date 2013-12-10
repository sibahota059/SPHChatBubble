//
//  WebViewController.h
//
//  Created by Mark Sands on 7/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIActionSheetDelegate, UIWebViewDelegate> {
  UIWebView *webView;
  NSURL *url;

  UIToolbar* toolbar;

  UIBarButtonItem *backButton;
  UIBarButtonItem *forwardButton;
  UIBarButtonItem *actionButton;
    UIBarButtonItem *gobackBtn;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSURL *url;

@property (nonatomic, retain) UIToolbar* toolbar;
@property (nonatomic, retain) UIBarButtonItem *backButton;
@property (nonatomic, retain) UIBarButtonItem *forwardButton;
@property (nonatomic, retain) UIBarButtonItem *actionButton;
@property (nonatomic, retain) UIBarButtonItem *gobackBtn;

- (id) initWithURL:(NSURL*)u;
- (void) doAction;

- (void)goBack;
- (void)goForward;

- (void)reload;
- (void)stop;

@end
