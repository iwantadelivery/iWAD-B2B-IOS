//
//  PersonalInfoViewController.h
//  iWad
//
//  Created by Saman Kumara on 12/18/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "SideViewController.h"

@protocol UserProfileDelegate <NSObject>

@optional

-(void)userDidPickImage:(UIImage *)userImage;

@end

@interface PersonalInfoViewController : SideViewController

@property (nonatomic, weak) id <UserProfileDelegate> delegate;

@end
