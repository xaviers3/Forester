//
//  WelcomeViewController.m
//  Forester
//
//  Created by CS3714 on 11/29/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	/***************************************************************************************
    *  A Tap is a discrete gesture, which sends only one action message when it occurs.   *
    **************************************************************************************/
    
    // Instantiate Tap Gesture Recognizer objects with target and a method to handle specific tap gesture
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(handleSingleTap:)];
    
    // Add Tap Gesture Recognizers to the imageView
    [self.welcomeImage addGestureRecognizer:singleTap];
    self.welcomeMessage.alpha = 0.0;
    self.continueMessage.alpha = 0.0;
    self.welcomeImage.alpha = 0.0;
    self.birdsFlyingRightImage.alpha = 0.0;
    self.birdsFlyingLeftImage.alpha = 0.0;
    self.welcomeImage.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [self fadeInWelcome];
    [self fadeInContinue];
    
    //Animate Trees
    [self animateTree];
    
    //Animate Birds
    [self animateBirds];
    [self passover];
}

#pragma mark - Tap Handling Method
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
   [self performSegueWithIdentifier:@"toApp" sender:self];
}

#pragma mark - Animations
-(void)fadeInWelcome{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.50];
    
    self.welcomeMessage.alpha = 1.0;
    self.welcomeImage.alpha = 1.0;
    
    [UIView commitAnimations];

}
-(void)fadeInContinue{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.50];
    [UIView setAnimationDelay:5.0];
    self.continueMessage.alpha = 1.0;
    
    [UIView commitAnimations];
}

-(void)animateTree{
    
    //Center: 221,144
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:3.30];
    self.welcomeImage.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    
    [UIView commitAnimations];
}

-(void)animateBirds{
    
    //Fly birds to the right
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.30];
    [UIView setAnimationDelay:2.30];
        self.birdsFlyingRightImage.alpha = 1.0;
    self.birdsFlyingRightImage.center = CGPointMake(380, -50);
    [UIView commitAnimations];
    
    
    //Fly birds to the left
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.30];
    [UIView setAnimationDelay:2.30];
    self.birdsFlyingLeftImage.alpha = 1.0;
    self.birdsFlyingLeftImage.center = CGPointMake(-50, -50);
    [UIView commitAnimations];
    
}

-(void)passover{
    //Passover
    self.birdsFlyingOverImage.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.birdsFlyingOverImage.center = CGPointMake(-210, -210);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.30];
    [UIView setAnimationDelay:4.30];
    self.birdsFlyingOverImage.alpha = 1.0;
    self.birdsFlyingOverImage.center = CGPointMake(470, 570);
    [UIView commitAnimations];
}


















@end
