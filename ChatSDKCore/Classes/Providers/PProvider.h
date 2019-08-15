//
//  PProvider.h
//  Pods
//
//  Created by ben3 on 14/08/2019.
//

#ifndef PProvider_h
#define PProvider_h

#import <Foundation/Foundation.h>

@protocol PProvider <NSObject>

@optional
-(NSString *) provideString: (id) object;

@end

#endif /* PProvider_h */
