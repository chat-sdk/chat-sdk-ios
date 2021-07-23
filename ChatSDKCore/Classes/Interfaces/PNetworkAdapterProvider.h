//
//  PNetworkAdapterProvider.h
//  Pods
//
//  Created by ben3 on 06/07/2021.
//

#ifndef PNetworkAdapterProvider_h
#define PNetworkAdapterProvider_h

@protocol PNetworkAdapter;

@protocol PNetworkAdapterProvider
    -(id<PNetworkAdapter>) getNetworkAdapter;
@end

#endif /* PNetworkAdapterProvider_h */
