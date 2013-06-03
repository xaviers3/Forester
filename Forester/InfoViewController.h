//
//  InfoViewController.h
//  Forester
//
//  Created by CS4704 on 12/14/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

/*
 We use the Delegation Design Pattern for the communication between the
 AddCityViewController object and the RootViewController Object.
 We define a protocol here and the RootViewController adopts it.
 */
@protocol InfoViewControllerDelegate;//-------------------------------------------------------------------

@interface InfoViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

//Delegate variables and methods
@property (nonatomic, assign) id <InfoViewControllerDelegate> delegate;
- (void)save:(id)sender;

//TextFields
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *subtitleTextField;

//Passed From upstream controller
@property (strong, nonatomic) NSString* titleOfAnnotation;
@property (strong, nonatomic) NSString* subtitleOfAnnotation;
@property  CLLocationCoordinate2D coord;
@property(strong, nonatomic) NSArray* annotations;
@property (strong, nonatomic) NSString* tripName;

//Buttons
- (IBAction)keyboardDone:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

//Image
@property(nonatomic, retain) UIImagePickerController *imgPicker;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView;
@property(strong, nonatomic) UIImage* selectedImage;

@property (strong, nonatomic) IBOutlet UIButton *selectPhotoButton;
- (IBAction)selectPhoto:(id)sender;
@end//----------------------------------------------------------------------------------------------------

/*
 The Protocol must be specified after the Interface specification is ended.
 Guidelines:
 - Create a protocol name as ClassNameDelegate as we did above.
 - Create a protocol method name starting with the name of the class defining the protocol.
 - Make the first method parameter to be the object reference of the caller as we did below.
 */
@protocol InfoViewControllerDelegate

- (void)infoViewController:(InfoViewController *)controller didFinishWithSave:(BOOL)save;
@end
