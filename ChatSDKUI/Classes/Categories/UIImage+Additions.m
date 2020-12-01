#import "UIImage+Additions.h"

@implementation UIImage(Additions)

-(NSString *) saveImageToFileWithName: (NSString *) name withFolder: (NSString *) folder {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

	// If you go to the folder below, you will find those pictures

    NSString * fileName = [NSString stringWithFormat:@"%@.png", name];

	NSString *pngFolderPath = [docDir stringByAppendingPathComponent:folder];
    NSString *pngFilePath = [pngFolderPath stringByAppendingPathComponent:fileName];

    // Check if the folder exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:pngFolderPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:pngFolderPath withIntermediateDirectories:NO attributes:nil error:Nil];

    // Delete the image if it exists already
    if ([[NSFileManager defaultManager] fileExistsAtPath:pngFilePath])
        [[NSFileManager defaultManager] removeItemAtPath:pngFilePath error:Nil];

	NSLog(@"Saving png: %@ ...", name);
	NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(self)];
	[data1 writeToFile:pngFilePath atomically:YES];

    return pngFilePath;
}

+(UIImage *) getImageForPath: (NSString *) path {
    return [UIImage imageWithContentsOfFile:path];
}

+(UIImage *) getImageFromFile: (NSString *) name withFolder: (NSString *) folder {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * fileName = [NSString stringWithFormat:@"%@.png", name];

	NSString *pngFolderPath = [docDir stringByAppendingPathComponent:folder];
    NSString *pngFilePath = [pngFolderPath stringByAppendingPathComponent:fileName];
	NSLog(@"Loading png: %@ ...", name);
    return [self getImageForPath:pngFilePath];
}

+(NSString *) getPathForFile: (NSString *) name withFolder: (NSString *) folder {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * fileName = [NSString stringWithFormat:@"%@.png", name];

	NSString *pngFolderPath = [docDir stringByAppendingPathComponent:folder];
    return [pngFolderPath stringByAppendingPathComponent:fileName];
}

+(UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size {
    double newCropWidth, newCropHeight;

    //=== To crop more efficently =====//
    if(image.size.width < image.size.height){
         if (image.size.width < size.width) {
                 newCropWidth = size.width;
          }
          else {
                 newCropWidth = image.size.width;
          }
          newCropHeight = (newCropWidth * size.height)/size.width;
    } else {
          if (image.size.height < size.height) {
                newCropHeight = size.height;
          }
          else {
                newCropHeight = image.size.height;
          }
          newCropWidth = (newCropHeight * size.width)/size.height;
    }
    //==============================//

    double x = image.size.width/2.0 - newCropWidth/2.0;
    double y = image.size.height/2.0 - newCropHeight/2.0;

    CGRect cropRect = CGRectMake(x, y, newCropWidth, newCropHeight);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);

    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

    return cropped;
}

@end
