# Runtime
[源码](https://opensource.apple.com/tarballs/objc4/)
## 类与对象
### runtime定义
* class
```
typedef struct objc_class *Class;


struct objc_class {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
    Class _Nullable super_class;                              
    const char * _Nonnull name;                             
    long version;                              
    long info;                                                
    long instance_size;                                     
    struct objc_ivar_list * _Nullable ivars;   //成员变量list              
    struct objc_method_list * _Nullable * _Nullable methodLists;  //方法list                  
    struct objc_cache * _Nonnull cache;        //方法cache   
    struct objc_protocol_list * _Nullable protocols;    //  协议列表  
}
```
category
```
struct objc_category {
    char * _Nonnull category_name                            ;
    char * _Nonnull class_name                               ;
    struct objc_method_list * _Nullable instance_methods     ;
    struct objc_method_list * _Nullable class_methods        ;
    struct objc_protocol_list * _Nullable protocols          ;
}
```

* object
```
typedef struct objc_object *id;


struct objc_object {
Class _Nonnull isa;
};

```
### 实际执行后转换
```
//Class的实际结构
struct _class_t {
    struct _class_t *isa;        //isa指针
    struct _class_t *superclass; //父类
    void *cache;
    void *vtable;
    struct _class_ro_t *ro;     //Class包含的信息
};
 
//Class包含的信息
struct _class_ro_t {
    unsigned int flags;
    unsigned int instanceStart;
    unsigned int instanceSize;
    unsigned int reserved;
    const unsigned char *ivarLayout;
    const char *name;                                 //类名
    const struct _method_list_t *baseMethods;         //方法列表
    const struct _objc_protocol_list *baseProtocols;  //协议列表
    const struct _ivar_list_t *ivars;                 //ivar列表
    const unsigned char *weakIvarLayout;
    const struct _prop_list_t *properties;            //属性列表
};

 //NyanCat(meta-class)
struct _class_t OBJC_METACLASS_$_NyanCat  = {
    .isa        = &OBJC_METACLASS_$_NSObject,
    .superclass = &OBJC_METACLASS_$_NSObject,
    .cache      = (void *)&_objc_empty_cache,
    .vtable     = (void *)&_objc_empty_vtable,
    .ro         = &_OBJC_METACLASS_RO_$_NyanCat, //包含了类方法等
};
 
//NyanCat(Class)
struct _class_t OBJC_CLASS_$_NyanCat = {
    .isa        = &OBJC_METACLASS_$_NyanCat,   //此处isa指向meta-class
    .superclass = &OBJC_CLASS_$_NSObject,
    .superclass = (void *)&_objc_empty_cache,
    .vtable     = (void *)&_objc_empty_vtable,
    .ro         = &_OBJC_CLASS_RO_$_NyanCat,   //包含了实例方法 ivar信息等
};
```
* 在objc中，id代表了一个对象。根据上面的声明，凡是首地址是*isa的struct指针，都可以被认为是objc中的对象。运行时可以通过isa指针，查找到该对象是属于什么类(Class)。
* 实例的isa指向了一个全局的Class, Class中记录了类名、成员变量信息、property信息、protocol信息和实例方法列表等
* Class的isa指向一个全局的meta-class，meta-class中记录类名，类方法列表等
### 继承
* 关系图 ![avatar](/类继承.jpg)
* [测试代码](/Inherit.m)

## 消息转发
### 相关名词
* [官方文档](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtHowMessagingWorks.html#//apple_ref/doc/uid/TP40008048-CH104-SW1)
* 函数原型: id objc_msgSend(id self, SEL _cmd, ... )。
self接受者，_cmd方法名，...参数
当向一般对象发送消息时，调用objc_msgSend；当向super发送消息时，调用的是objc_msgSendSuper； 如果返回值是一个结构体，则会调用objc_msgSend_stret或objc_msgSendSuper_stret。
* SEL 表示选择器，这是一个不透明结构体。但是实际上，通常可以把它理解为一个字符串。例如printf(“%s”,@selector(isEqual:))会打印出”isEqual:”。运行时维护着一张SEL的表，将相同字符串的方法名映射到唯一一个SEL。  通过sel_registerName(char *name)方法，可以查找到这张表中方法名对应的SEL。苹果提供了一个语法糖@selector用来方便地调用该函数。
* IMP是一个函数指针。objc中的方法最终会被转换成纯C的函数，IMP就是为了表示这些函数的地址。
### 流程
* 查找IMP--------
0. if self == nil { retrun }
1. 在class的缓存中查找imp，找到后，调用imp。
2. 在方法列表中查找，找到后放入缓存中，调用imp。
3. 到父类的class的缓存中查找，找到后，加入到当前class的缓存中，调用imp
4. 在父类的class的方法列表中查找，找到后放入当前calss的缓存中，调用imp
5. 重复3，4步骤，直到NSObject中依然没有找到imp，则将imp指向_objc_msgForward，进入消息转发流程
* 消息转发------[demo](/msg_send.m)
1. 调用resolveInstanceMethod:方法，允许用户在此时为该Class动态添加实现。如果有实现了，则调用并返回。如果仍没实现，继续下面的动作。
2. 调用forwardingTargetForSelector:方法，尝试找到一个能响应该消息的对象。如果获取到，则直接转发给它。如果返回了nil，继续下面的动作。
3. 调用methodSignatureForSelector:方法，尝试获得一个方法签名。如果获取不到，则直接调用doesNotRecognizeSelector抛出异常。
4. 调用forwardInvocation:方法，将地3步获取到的方法签名包装成Invocation传入，如何处理就在这里面了
## 应用
1.[ category动态添加属性](/associatedObject.m)
2. [切面编程](https://github.com/steipete/Aspects)
3. json&model, [YYModel](https://github.com/ibireme/YYModel), [jsonmodel](https://github.com/jsonmodel/jsonmodel)
4. [热更新](https://github.com/bang590/JSPatch)
