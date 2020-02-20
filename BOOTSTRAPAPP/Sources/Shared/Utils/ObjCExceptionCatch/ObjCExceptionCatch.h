//
//  ObjCExceptionCatch.h
//  BOOTSTRAPAPP
//
//  Created by __AUTHOR__.
//  Copyright © __YEAR__-present __ORGANIZATION__. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CatchBlock)(void);

@interface ObjC: NSObject
+ (BOOL)catchException:(CatchBlock)tryBlock error:(__autoreleasing NSError **)error;
@end


NS_ASSUME_NONNULL_END
