//
//  SPHBubbleCellImageOther.h
//  ChatBubble
//
//  Created by ivmac on 10/2/13.
//  Copyright (c) 2013 Conciergist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPHChatData.h"

@interface SPHBubbleCellImageOther : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *message_Image;
@property (weak, nonatomic) IBOutlet UIImageView *Buble_image;
@property (weak, nonatomic) IBOutlet UIImageView *Avatar_Image;

@property (weak, nonatomic) IBOutlet UILabel *time_Label;

-(void)SetCellData:(SPHChatData *)feed_data;

@end
