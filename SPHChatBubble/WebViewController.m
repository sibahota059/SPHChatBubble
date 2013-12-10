//
//  WebViewController.m
//
//  Created by Mark Sands on 7/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <objc/runtime.h>
#import "SPHAppDelegate.h"
#import "WebViewController.h"

typedef enum {
	BUTTON_RELOAD,
	BUTTON_STOP,
} ToolbarButton;

@interface WebViewController (Private)
- (void)updateToolbar:(ToolbarButton)state;
@end;

@implementation WebViewController

@synthesize webView;
@synthesize url;
@synthesize gobackBtn;
@synthesize toolbar, backButton, forwardButton, actionButton;

- (id) initWithURL:(NSURL *)u
{
  if ( self = [super init] )
  {
    backButton    = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
    actionButton  = [[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(doAction)];
    gobackBtn  = [[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(gobackView)];

    toolbar           = [UIToolbar new];
    toolbar.barStyle  = UIBarStyleDefault;
    toolbar.tintColor = [UIColor lightGrayColor];
    
    [toolbar sizeToFit];
    CGFloat toolbarHeight = [toolbar frame].size.height;
    CGRect mainViewBounds = self.view.bounds;
    [toolbar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
                                 CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - (toolbarHeight * 2.0) + 2.0,
                                 CGRectGetWidth(mainViewBounds),
                                 toolbarHeight)];		

    webView                 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 380)];
    webView.delegate        = self;
    webView.scalesPageToFit = YES;

    url = [u copy];
    
    [self.view addSubview:webView];
    [self.view addSubview:toolbar];

    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *items = [NSArray arrayWithObjects: gobackBtn,flexItem, backButton, flexItem, flexItem, flexItem, forwardButton,
                                                flexItem, flexItem, flexItem, flexItem, flexItem, flexItem,
                                                actionButton, flexItem, flexItem, flexItem, actionButton, flexItem, nil];
    [self.toolbar setItems:items animated:NO];
    
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
  }
  return self;
}

-(void)gobackView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [webView stopLoading];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark WebViewActions

- (void)reload
{
  [webView reload];
  [self updateToolbar:BUTTON_STOP];
}

- (void)stop
{
  [webView stopLoading];
  [self updateToolbar:BUTTON_RELOAD];
}

- (void) goBack
{
  [webView goBack];
}

- (void) goForward
{
  [webView goForward];
}

- (void) doAction
{
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[self.url absoluteString]
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"Open with Safari", nil];

  [actionSheet showInView:self.navigationController.view];
  [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)as clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (as.cancelButtonIndex == buttonIndex) return;

  if (buttonIndex == 0) {    
    // swizzle methods, from here we want to open Safari
    
    Method customOpenUrl = class_getInstanceMethod([UIApplication class], @selector(customOpenURL:));
    Method openUrl = class_getInstanceMethod([UIApplication class], @selector(openURL:));

    method_exchangeImplementations(customOpenUrl, openUrl);	
    
    [[UIApplication sharedApplication] openURL:self.url];
  }
}

#pragma mark -
#pragma mark UIWebView

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  return true;
}

- (void)webViewDidStartLoad:(UIWebView *)aWebView
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  [self updateToolbar:BUTTON_STOP];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  self.title = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
  [self updateToolbar:BUTTON_RELOAD];
  self.url = aWebView.request.mainDocumentURL;
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;	
}

-(void)updateToolbar:(ToolbarButton)button
{
  NSMutableArray *items = [toolbar.items mutableCopy];
  UIBarButtonItem *newItem;

  if (button == BUTTON_STOP) {
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityView startAnimating];
    newItem = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    [activityView release];
  }
  else {
    newItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)] autorelease];
  }

  [items replaceObjectAtIndex:12 withObject:newItem];
  [toolbar setItems:items animated:false];
  [items release];

  // workaround to change toolbar state
  backButton.enabled = true;
  forwardButton.enabled = true;
  backButton.enabled = false;
  forwardButton.enabled = false;

  backButton.enabled = (webView.canGoBack) ? true : false;
  forwardButton.enabled = (webView.canGoForward) ? true : false;
}

#pragma mark -

- (void)dealloc
{
  [webView release];
  [url release];
  [toolbar release];

  [backButton release];
  [forwardButton release];
  [actionButton release];

  [super dealloc];
}

@end