//
//  TestBlock.m
//  a
//
//  Created by clobotics_ccp on 2019/9/23.
//  Copyright © 2019 cool-ccp. All rights reserved.
//

@implementation SubClass

@interface Test1Class: NSObject
@end

@interface SubClass: NSObject
@end

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return true;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSString *name = NSStringFromSelector(aSelector);
    if ([NSStringFromSelector(aSelector) isEqualToString:@"test_1"]) {
        return [Test1Class new];
    }
    return self;
}

- (void)replaceMethod {
    NSLog(@"replaceMethod");
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"test_2"]) {
        
        return [NSMethodSignature signatureWithObjCTypes:"@@:"];
    }
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    if ([NSStringFromSelector(anInvocation.selector) isEqualToString:@"test_2"]) {
        anInvocation.selector = sel_registerName("replaceMethod");
        [anInvocation invokeWithTarget:self];
    }
    
}

@end

@implementation Test1Class

- (void)test_1 {
    NSLog(@"%@ forwardingTargetForSelector to %@", NSStringFromSelector(_cmd), self);
}

@end





