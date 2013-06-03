//
//  ButtonLoader.m
//  Forester
//
//  Created by CS4704 on 12/15/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import "ButtonLoader.h"

@implementation ButtonLoader

+(void) loadButtonImage:(UIButton*) button{
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal
											 stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [button setBackgroundImage:stretchableButtonImageNormal
                      forState:UIControlStateNormal];
	
    UIImage *buttonImagePressed = [UIImage imageNamed:@"blueButton.png"];
    UIImage *stretchableButtonImagePressed = [buttonImagePressed
											  stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[button setBackgroundImage:stretchableButtonImagePressed
                      forState:UIControlStateHighlighted];
    
}
@end
