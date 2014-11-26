//
//  SPHViewController.m
//  SPHChatBubble
//
//  Created by Siba Prasad Hota  on 10/18/13.
//  Copyright (c) 2013 Wemakeappz. All rights reserved.
//

#import "SPHViewController.h"
#import "SPHChatData.h"
#import "WebViewController.h"
#import "SPHChatData.h"
#import "SPHBubbleCell.h"
#import "SPHBubbleCellImage.h"
#import "SPHBubbleCellImageOther.h"
#import "SPHBubbleCellOther.h"
#import <QuartzCore/QuartzCore.h>
#import "AsyncImageView.h"
#import "MHFacebookImageViewer.h"
#import "QBPopupMenu.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SPHAppDelegate.h"





@interface SPHViewController ()

@end

@implementation SPHViewController

@synthesize pullToRefreshManager = pullToRefreshManager_;
@synthesize reloads = reloads_;

@synthesize imgPicker;
@synthesize Uploadedimage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SPHAppDelegate *MyWatcher = [[UIApplication sharedApplication] delegate];
    MyWatcher.currentViewController = self;
    
    sphBubbledata=[[NSMutableArray alloc]init];
    
    [self setUpTextFieldforIphone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    pullToRefreshManager_ = [[MNMPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f
                                                                                   tableView:self.sphChatTable
                                                                                  withClient:self];
    [self setUpDummyMessages];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)handleURL:(NSURL*)url
{
    WebViewController *controller = [[[WebViewController alloc] initWithURL:url] autorelease];
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)setUpDummyMessages
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *rowNumber=[NSString stringWithFormat:@"%d",(int)sphBubbledata.count];
    [self adddBubbledata:ktextByme mtext:@"Hi!!!!!!!" mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:kStatusSeding];
    [self performSelector:@selector(messageSent:) withObject:rowNumber afterDelay:1.0];
    [self adddBubbledata:ktextbyother mtext:@"Heloo!!!!!" mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:kStatusSent];
    rowNumber=[NSString stringWithFormat:@"%d",(int)sphBubbledata.count];
    [self adddBubbledata:ktextByme mtext:@"How are you doing today?" mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:kStatusSeding];
    [self performSelector:@selector(messageSent:) withObject:rowNumber afterDelay:1.5];
    [self adddBubbledata:ktextbyother mtext:@"I'm doing great! what abt you?" mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:kStatusSent];
}

#pragma mark MNMBottomPullToRefreshManagerClient

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [pullToRefreshManager_ tableViewScrolled];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y >=360.0f)
    {
    }
    else
        [pullToRefreshManager_ tableViewReleased];
}

- (void)pullToRefreshTriggered:(MNMPullToRefreshManager *)manager
{
    reloads_++;
    [self performSelector:@selector(getEarlierMessages) withObject:nil afterDelay:0.0f];
}

-(void)getEarlierMessages
{
    NSLog(@"get Earlir Messages And Appand to Array");
     [self performSelector:@selector(loadfinished) withObject:nil afterDelay:1];
}

-(void)loadfinished
{
    [pullToRefreshManager_ tableViewReloadFinishedAnimated:YES];
    [self.sphChatTable reloadData];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)setUpTextFieldforIphone
{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-40, 320, 40)];
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(40, 3, 206, 40)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 6;
	textView.returnKeyType = UIReturnKeyDefault; //just as an example
	textView.font = [UIFont systemFontOfSize:15.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(40, 0,210, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    UIImage *camBtnBackground = [[UIImage imageNamed:@"cam.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    
    
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"send" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[containerView addSubview:doneBtn];
    
    
    
    UIButton *doneBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn2.frame = CGRectMake(containerView.frame.origin.x+1,2, 35,40);
    doneBtn2.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
	[doneBtn2 setTitle:@"" forState:UIControlStateNormal];
    
    [doneBtn2 setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn2.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn2 addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn2 setBackgroundImage:camBtnBackground forState:UIControlStateNormal];
    
    //[doneBtn2 setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
    
	[containerView addSubview:doneBtn2];
    
    
    
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
}

-(void)resignTextView{
    if ([textView.text length]<1) {
        
    }
    else
    {
        NSString *chat_Message=textView.text;
        textView.text=@"";
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"hh:mm a"];
       
        NSString *rowNumber=[NSString stringWithFormat:@"%d",(int)sphBubbledata.count];
        
        if (sphBubbledata.count%2==0) {
            [self adddBubbledata:ktextByme mtext:chat_Message mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:kStatusSeding];
        }else{
            [self adddBubbledata:ktextbyother mtext:chat_Message mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:kStatusSeding];
 
        }
                
        [self performSelector:@selector(messageSent:) withObject:rowNumber afterDelay:2.0];
}

}

-(IBAction)messageSent:(id)sender
{
    NSLog(@"row= %@", sender);
    SPHChatData *feed_data=[[SPHChatData alloc]init];
    feed_data=[sphBubbledata objectAtIndex:[sender intValue]];
    feed_data.messagestatus=@"Sent";
    [sphBubbledata replaceObjectAtIndex:[sender intValue] withObject:feed_data ];
    
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:[sender intValue] inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.sphChatTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
}


-(IBAction)uploadImage:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.mediaTypes = [NSArray arrayWithObjects:
                                (NSString *) kUTTypeImage,
                                nil];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        newMedia = NO;
    }
}

//http://www.binarytribune.com/wp-content/uploads/2013/06/india_binary_options-274x300.png

-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        
        Uploadedimage.image=image;
        
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
		// Code here to support video if enabled
	}
    
   [self performSelector:@selector(uploadToServer) withObject:nil afterDelay:0.0];
}

-(void)uploadToServer
{
    NSString *chat_Message=textView.text;
    textView.text=@"";
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"hh:mm a"];
    
    NSString *rowNumber=[NSString stringWithFormat:@"%d",(int)sphBubbledata.count];
    
    if (sphBubbledata.count%2==0) {
        [self adddBubbledata:kImageByme mtext:chat_Message mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:kStatusSeding];
    }else{
        [self adddBubbledata:kImageByOther mtext:chat_Message mtime:[formatter stringFromDate:date] mimage:Uploadedimage.image msgstatus:kStatusSeding];
        
    }
    
    [self performSelector:@selector(messageSent:) withObject:rowNumber afterDelay:1.0];
}



-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return sphBubbledata.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SPHChatData *feed_data=[[SPHChatData alloc]init];
    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
    
    if ([feed_data.messageType isEqualToString:ktextByme]||[feed_data.messageType isEqualToString:ktextbyother])
    {
        float cellHeight;
        // text
        NSString *messageText = feed_data.messageText;
        //
        CGSize boundingSize = CGSizeMake(messageWidth-20, 10000000);
        CGSize itemTextSize = [messageText sizeWithFont:[UIFont systemFontOfSize:14]
                                      constrainedToSize:boundingSize
                                          lineBreakMode:NSLineBreakByWordWrapping];
        
        // plain text
        cellHeight = itemTextSize.height;
        
        if (cellHeight<25) {
            
            cellHeight=25;
        }
        return cellHeight+30;
    }
    else{
        return 140;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.sphChatTable deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    SPHChatData *feed_data=[[SPHChatData alloc]init];
    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier1 = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
    static NSString *CellIdentifier3 = @"Cell3";
    static NSString *CellIdentifier4 = @"Cell4";
    
    if ([feed_data.messageType isEqualToString:ktextByme])
    {
        SPHBubbleCellOther  *cell = (SPHBubbleCellOther *)[self.sphChatTable dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SPHBubbleCellOther" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        [cell SetCellData:feed_data targetedView:self Atrow:indexPath.row];
        [cell.Avatar_Image setupImageViewer];
        
        return cell;
    }
    
    if ([feed_data.messageType isEqualToString:ktextbyother])
    {
        SPHBubbleCell  *cell = (SPHBubbleCell *)[self.sphChatTable dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        if (cell == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SPHBubbleCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        [cell SetCellData:feed_data targetedView:self Atrow:indexPath.row];
        [cell.Avatar_Image setupImageViewer];
        return cell;
    }
    
    if ([feed_data.messageType isEqualToString:kImageByme])
    {
        SPHBubbleCellImage  *cell = (SPHBubbleCellImage *)[self.sphChatTable dequeueReusableCellWithIdentifier:CellIdentifier3];
        if (cell == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SPHBubbleCellImage" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        [cell SetCellData:feed_data];
        [cell.Avatar_Image setupImageViewer];
        cell.message_Image.image=Uploadedimage.image;
        [cell.message_Image setupImageViewer];
        return cell;
    }
    
    SPHBubbleCellImageOther  *cell = (SPHBubbleCellImageOther *)[self.sphChatTable dequeueReusableCellWithIdentifier:CellIdentifier4];
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SPHBubbleCellImageOther" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    [cell.message_Image setupImageViewer];
    [cell.Avatar_Image setupImageViewer];
     cell.message_Image.imageURL=[NSURL URLWithString:@"http://www.binarytribune.com/wp-content/uploads/2013/06/india_binary_options-274x300.png"];
    return cell;
}


-(void)adddBubbledata:(NSString*)messageType  mtext:(NSString*)messagetext mtime:(NSString*)messageTime mimage:(UIImage*)messageImage  msgstatus:(NSString*)status;
{
    SPHChatData *feed_data=[[SPHChatData alloc]init];
    feed_data.messageText=messagetext;
    feed_data.messageImageURL=messagetext;
    feed_data.messageImage=messageImage;
    feed_data.messageTime=messageTime;
    feed_data.messageType=messageType;
    feed_data.messagestatus=status;
   
    
    NSArray *insertIndexPaths = [NSArray arrayWithObject:
                                 [NSIndexPath indexPathForRow:
                                  [sphBubbledata count] // is also 1 now, hooray
                                                    inSection:0]];
    
     [sphBubbledata addObject:feed_data];
    
    [[self sphChatTable] insertRowsAtIndexPaths:insertIndexPaths
                            withRowAnimation:UITableViewRowAnimationNone];
    
    [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.1];
}

-(void)adddBubbledataatIndex:(NSInteger)rownum messagetype:(NSString*)messageType  mtext:(NSString*)messagetext mtime:(NSString*)messageTime mimage:(UIImage*)messageImage  msgstatus:(NSString*)status;
{
    SPHChatData *feed_data=[[SPHChatData alloc]init];
    feed_data.messageText=messagetext;
    feed_data.messageImageURL=messagetext;
     feed_data.messageImage=messageImage;
    feed_data.messageTime=messageTime;
    feed_data.messageType=messageType;
    feed_data.messagestatus=status;
    [sphBubbledata  replaceObjectAtIndex:rownum withObject:feed_data];
   
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:rownum inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.sphChatTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];

    
    
    [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.1];
}




-(void)tapRecognized:(UITapGestureRecognizer *)tapGR

{
    UITextView *theTextView = (UITextView *)tapGR.view;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:theTextView.tag inSection:0];
    SPHChatData *feed_data=[[SPHChatData alloc]init];
    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
    selectedRow=(int)indexPath.row;
    [self.sphChatTable reloadData];
    
    if ([feed_data.messageType isEqualToString:ktextByme])
    {
        SPHBubbleCellOther *mycell=(SPHBubbleCellOther*)[self.sphChatTable cellForRowAtIndexPath:indexPath];
        UIImageView *bubbleImage=(UIImageView *)[mycell viewWithTag:55];
        bubbleImage.image=[[UIImage imageNamed:@"Bubbletyperight_highlight"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        
    }else
        if ([feed_data.messageType isEqualToString:ktextbyother])
        {
            SPHBubbleCell *mycell=(SPHBubbleCell*)[self.sphChatTable cellForRowAtIndexPath:indexPath];
            UIImageView *bubbleImage=(UIImageView *)[mycell viewWithTag:56];
            bubbleImage.image=[[UIImage imageNamed:@"Bubbletypeleft_highlight"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        }
    CGPoint touchPoint = [tapGR locationInView:self.view];
    [self.popupMenu showInView:self.view atPoint:touchPoint];
    
    
    [self.sphChatTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.sphChatTable.delegate tableView:self.sphChatTable didSelectRowAtIndexPath:indexPath];
}

-(IBAction)bookmarkClicked:(id)sender
{
    NSLog( @"Book mark clicked at row : %d",selectedRow);
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}


-(void)scrollTableview
{
    if (sphBubbledata.count<3)
        return;
    
    NSInteger lastSection=[self.sphChatTable numberOfSections]-1;
    NSInteger lastRowNumber = [self.sphChatTable numberOfRowsInSection:lastSection]-1;
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:lastSection];
    [self.sphChatTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

-(void) keyboardWillShow:(NSNotification *)note
{
    if (sphBubbledata.count>2)
        [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.0];
   
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    // get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    
    CGRect tableviewframe=self.sphChatTable.frame;
    tableviewframe.size.height-=160;
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	containerView.frame = containerFrame;
    self.sphChatTable.frame=tableviewframe;
    
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    CGRect tableviewframe=self.sphChatTable.frame;
    tableviewframe.size.height+=160;
    
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	// set views with new info
    self.sphChatTable.frame=tableviewframe;
	containerView.frame = containerFrame;
	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}




- (IBAction)endViewedit:(id)sender {
    [self.view endEditing:YES];
}
@end
