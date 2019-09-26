//
//  SuperClass+TestCaregory.m
//  RuntimeTest
//
//  Created by clobotics_ccp on 2019/9/24.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

#import "SuperClass+TestCaregory.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

const void *testPropertyKey = &testPropertyKey;

@implementation SuperClass (TestCaregory)

- (NSString *)testProperty {
    return objc_getAssociatedObject(self, testPropertyKey);
}

- (void)setTestProperty:(NSString *)testProperty {
    objc_setAssociatedObject(self, testPropertyKey, testProperty, OBJC_ASSOCIATION_RETAIN);
}

@end
