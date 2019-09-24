//
//  Inherit.m
//  Inherit
//
//  Created by clobotics_ccp on 2019/9/24.
//  Copyright © 2019 cool-ccp. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface SuperClass : NSObject

@end

@implementation SuperClass


@end

@interface SubClass : SuperClass

@end

@implementation SubClass


@end


void printInfo(Class cls) {
    Class cls1 = object_getClass(cls);
    const char *name = class_getName(cls);
    if (memcmp(name, "nil", 3) == 0) { return; }
    const char *name1 = class_getName(cls1);
    BOOL isMeta = class_isMetaClass(cls);
    BOOL isMeta1 = class_isMetaClass(cls1);
    NSLog(@"cls: %@, %s, %d", cls, name, isMeta);
    NSLog(@"cls1: %@, %s, %d", cls1, name1, isMeta1);
    NSLog(@"nsobject: %@, %@", class_getSuperclass(NSClassFromString(@"NSObject")), [NSObject class]);
    printInfo(class_getSuperclass(cls));
}


void testObjectAndClass() {
    printInfo([[SubClass new] class]);
}

