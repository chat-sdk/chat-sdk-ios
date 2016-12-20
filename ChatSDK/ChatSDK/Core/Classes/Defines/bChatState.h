//
//  bChatState.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 04/09/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#ifndef bChatState_h
#define bChatState_h

typedef enum {
    bChatStateActive,
    bChatStateComposing,
    bChatStatePaused,
    bChatStateInactive,
    bChatStateGone,
} bChatState;

#endif /* bChatState_h */
