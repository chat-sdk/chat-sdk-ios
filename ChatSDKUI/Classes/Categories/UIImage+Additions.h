//
//  UIImage+Additions.h
//  Midi Manager
//
//  Created by Benjamin Smiley-andrews on 20/06/2013.
//  Copyright (c) 2013 Benjamin Smiley-andrews. All rights reserved.
//

@interface UIImage(Additions)

-(NSString *) saveImageToFileWithName: (NSString *) name withFolder: (NSString *) folder;
+(UIImage *) getImageFromFile: (NSString *) name withFolder: (NSString *) folder;
+(NSString *) getPathForFile: (NSString *) name withFolder: (NSString *) folder;
+(UIImage *) getImageForPath: (NSString *) path;

@end
