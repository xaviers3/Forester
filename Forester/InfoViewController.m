//
//  InfoViewController.m
//  Forester
//
//  Created by CS4704 on 12/14/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import "InfoViewController.h"
#import "ButtonLoader.h"

@interface InfoViewController ()

@property(strong, nonatomic) UIActionSheet* actionSheet;

@end

@implementation InfoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.allowsEditing = NO;
    self.imgPicker.delegate = self;
    [ButtonLoader loadButtonImage:self.selectPhotoButton];
    self.titleTextField.text = self.titleOfAnnotation;
    self.subtitleTextField.text = self.subtitleOfAnnotation;
    
    // Instantiate a Save button to invoke the save: method when tapped
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self action:@selector(save:)];
    
    // Set up the Save custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = saveButton;

    [self loadImage];
    
}


#pragma mark - Buttons
//Save Button Has been pressed
- (void)save:(id)sender{
    // Inform the delegate that the user tapped the Save button
    [self.delegate infoViewController:self didFinishWithSave:YES];
}


- (IBAction)keyboardDone:(id)sender
{
    [sender resignFirstResponder];  // Deactivate the keyboard
}

//Resign all keyboards when background is tapped
- (IBAction)backgroundTapped:(id)sender{
    [self.titleTextField resignFirstResponder];

    [self.subtitleTextField resignFirstResponder];
}

- (IBAction)selectPhoto:(id)sender {
    UIActionSheet *selectUploadType = [[UIActionSheet alloc] initWithTitle:@"Select Media Type" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select Image From Library", @"Take Picture", nil];
    
    //[self imagePickerController:nil didFinishPickingMediaWithInfo:nil];
    
    [selectUploadType setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    [selectUploadType setTag:1];
    [selectUploadType showInView:self.view];
}

#pragma mark - delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"run");
    self.selectedImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.selectedImageView.contentMode = UIViewContentModeCenter;
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //self.imgPicker.delegate = self;
    switch (actionSheet.tag)
    {
            // Select Upload Type actionsheet
        case 1:
            switch (buttonIndex) {
                    // Select Picture/Video
                case 0:
                    self.imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    [self presentViewController:self.imgPicker animated:YES completion:nil];
                    break;
                    // Take Picture
                case 1:
                    self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:self.imgPicker animated:YES completion:nil];
            }
    }
}



-(void) loadImage{
 
    //retain location and information of matching annotation data
    NSArray* annotationData;
    int index;
    
    //Locate Annotation object to modify (retrieve index number)
    for(index = 0; index < [self.annotations count]; index++){
        
        NSString *annotation = [self.annotations objectAtIndex:index];
        annotationData = [annotation componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        /*
         [annotationData objectAtIndex:0] --> Title
         [annotationData objectAtIndex:1] --> SubTitle
         [annotationData objectAtIndex:2] --> longitude
         [annotationData objectAtIndex:3] --> latitude
         */
        double longitude = [[annotationData objectAtIndex:2] doubleValue];
        double latitude  = [[annotationData objectAtIndex:3] doubleValue];
        double cLongitude = self.coord.longitude;
        double cLatitude = self.coord.latitude;
        
        //Check for a match. If found break, We have our index value
        if(fabs(longitude - cLongitude) <= 0.000001 && fabs(latitude - cLatitude) < 0.000001){
            //printf("index: %d", index);
            break;
        }

    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%d.%@",self.tripName, index, @"jpg"]];
     NSLog(@"image path: %@", imagePath);
    NSFileManager *manager = [[NSFileManager alloc] init];
    if([manager fileExistsAtPath:imagePath]){
        self.selectedImage = [UIImage imageWithContentsOfFile:imagePath];
        self.selectedImageView.image = self.selectedImage;
    }
}


@end
