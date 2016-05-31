//
//  ProfileViewController.h
//  iWad
//
//  Created by Saman Kumara on 12/18/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "SideViewController.h"

@protocol ProfileViewDelegate <NSObject>

@optional

-(void)userDidPickImage:(UIImage *)userImage;

@end

@interface ProfileViewController : UIViewController

@property (nonatomic, weak) id <ProfileViewDelegate> delegate;

@end
