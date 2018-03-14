//
//  PHasMeta.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 22/08/2016.
//
//

#ifndef PHasMeta_h
#define PHasMeta_h

@protocol PHasMeta <NSObject>

-(NSString *) metaStringForKey: (NSString *) key;
-(id) metaValueForKey: (NSString *) key;
-(void) setMetaValue: (id) value forKey: (NSString *) key;
-(void) setMetaString: (NSString *) value forKey: (NSString *) key;
-(NSDictionary *) metaDictionary;
-(void) setMetaDictionary: (NSDictionary *) meta;

@end

#endif /* PHasMeta_h */
