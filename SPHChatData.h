//
//  SPHChatData.h
//  ChatBubble
//
//  Created by ivmac on 10/2/13.
//  Copyright (c) 2013 Conciergist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPHChatData : NSObject

@property(nonatomic,retain)NSString *messageText;
@property(nonatomic,retain)NSString *avatarImageURL;
@property(nonatomic,retain)NSString *messageImageURL;
@property(nonatomic,retain)NSString *messageTime;
@property(nonatomic,retain)NSString *bubbleImageName;
@property(nonatomic,retain)NSString *messageType;
@property(nonatomic,retain)NSString *messagestatus;
@property(nonatomic,retain)NSString *messagesfrom;
@property(nonatomic,retain)UIImage *messageImage;

@end
