//
//  WelcomeViewController.h
//  Forester
//
//  Created by CS3714 on 11/29/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *welcomeImage;
@property (strong, nonatomic) IBOutlet UILabel *welcomeMessage;
@property (strong, nonatomic) IBOutlet UILabel *continueMessage;
@property (strong, nonatomic) IBOutlet UIImageView* birdsFlyingRightImage;
@property (strong, nonatomic) IBOutlet UIImageView* birdsFlyingLeftImage;
@property (strong, nonatomic) IBOutlet UIImageView *birdsFlyingOverImage;
@end
