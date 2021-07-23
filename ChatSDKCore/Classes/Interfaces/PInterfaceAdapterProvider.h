//
//  PInterfaceAdapterProvider.h
//  Pods
//
//  Created by ben3 on 06/07/2021.
//

#ifndef PInterfaceAdapterProvider_h
#define PInterfaceAdapterProvider_h

@protocol PInterfaceAdapter;

@protocol PInterfaceAdapterProvider
    -(id<PInterfaceAdapter>) getInterfaceAdapter;
@end

#endif /* PInterfaceAdapterProvider_h */
