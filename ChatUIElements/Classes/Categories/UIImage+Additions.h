//
//  UIImage+Additions.h
//  Midi Manager
//
//  Created by Benjamin Smiley-andrews on 20/06/2013.
//  Copyright (c) 2013 Benjamin Smiley-andrews. All rights reserved.
//

@interface UIImage (Additions)

-(NSString *) saveImageToFileWithName: (NSString *) name withFolder: (NSString *) folder;
+(UIImage *) getImageFromFile: (NSString *) name withFolder: (NSString *) folder;
+(NSString *) getPathForFile: (NSString *) name withFolder: (NSString *) folder;
+(UIImage *) getImageForPath: (NSString *) path;

@end

@implementation UIImage (Additions)

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

@end


