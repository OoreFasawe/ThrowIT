//
//  Utility.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/15/22.
//

#import "Utility.h"

@implementation Utility

+(void)TakeOrChooseImage:(UIViewController *)viewController withSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = viewController;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = sourceType;
    [viewController presentViewController:imagePickerVC animated:YES completion:nil];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image)
        return nil;
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData)
        return nil;
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}


@end
