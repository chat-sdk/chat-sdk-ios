//
//  bMessageStatus.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 03/03/2016.
//
//

#ifndef bMessageStatus_h
#define bMessageStatus_h

//typedef enum  {
//    bMessageDeliveryStatusNone = 0,
//    bMessageDeliveryStatusDispatched = 1,
//    bMessageDeliveryStatusServerReceived = 2,
//} bMessageDeliveryStatus;

typedef enum {
    bMessageReadStatusNotSet = -2,
    bMessageReadStatusHide = -1,
    bMessageReadStatusNone = 0,
    bMessageReadStatusDelivered = 1,
    bMessageReadStatusRead = 2,
} bMessageReadStatus;

#endif /* bMessageStatus_h */
