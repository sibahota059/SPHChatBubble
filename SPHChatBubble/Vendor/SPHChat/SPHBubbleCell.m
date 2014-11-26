//
//  SPHBubbleself.m
//  ChatBubble
//
//  Created by ivmac on 10/2/13.
//  Copyright (c) 2013 Conciergist. All rights reserved.
//

#import "SPHBubbleCell.h"



@implementation SPHBubbleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)SetCellData:(SPHChatData *)feed_data targetedView:(id)ViewControllerObject Atrow:(NSInteger)indexRow;
{
    NSString *messageText = feed_data.messageText;
    CGSize boundingSize = CGSizeMake(messageWidth-20, 10000000);
    CGSize itemTextSize = [messageText sizeWithFont:[UIFont systemFontOfSize:14]
                                  constrainedToSize:boundingSize
                                      lineBreakMode:NSLineBreakByWordWrapping];
    float textHeight = itemTextSize.height+7;
    int x=0;
    if (textHeight>200)
    {
        x=65;
    }else
        if (textHeight>150)
        {
            x=50;
        }
        else if (textHeight>80)
        {
            x=30;
        }else
            if (textHeight>50)
            {
                x=20;
            }else
                if (textHeight>30) {
                    x=8;
                }
    //[bubbleImage setFrame:CGRectMake(265-itemTextSize.width,5,itemTextSize.width+14,textHeight+4)];
    UIImageView *bubbleImage=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Bubbletypeleft"] stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    [self.contentView addSubview:bubbleImage];
    [bubbleImage setFrame:CGRectMake(50,5, itemTextSize.width+18, textHeight+4)];
    bubbleImage.tag=56;
    //CGRectMake(260 - itemTextSize.width+5,2,itemTextSize.width+10, textHeight-2)];
    UITextView *messageTextview=[[UITextView alloc]initWithFrame:CGRectMake(60,2,itemTextSize.width+10, textHeight-2)];
    [self.contentView addSubview:messageTextview];
    
    
    messageTextview.editable=NO;
    messageTextview.text = messageText;
    messageTextview.dataDetectorTypes=UIDataDetectorTypeAll;
    messageTextview.textAlignment=NSTextAlignmentJustified;
    messageTextview.backgroundColor=[UIColor clearColor];
    messageTextview.font=[UIFont fontWithName:@"Helvetica Neue" size:12.0];
    messageTextview.scrollEnabled=NO;
    messageTextview.tag=indexRow;
    messageTextview.textColor=[UIColor whiteColor];
    
    
    self.Avatar_Image.layer.cornerRadius = 20.0;
    self.Avatar_Image.layer.masksToBounds = YES;
    self.Avatar_Image.layer.borderColor = [UIColor whiteColor].CGColor;
    self.Avatar_Image.layer.borderWidth = 2.0;
    
    self.Avatar_Image.image=[UIImage imageNamed:@"my_icon"];
    self.time_Label.text=feed_data.messageTime;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:ViewControllerObject action:@selector(tapRecognized:)];
    [messageTextview addGestureRecognizer:singleFingerTap];
    singleFingerTap.delegate = ViewControllerObject;
}

@end
