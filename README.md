# Runtime
[源码](https://opensource.apple.com/tarballs/objc4/)
## 类与对象
### 结构
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
    struct objc_ivar_list * _Nullable ivars;                 
    struct objc_method_list * _Nullable * _Nullable methodLists;                    
    struct objc_cache * _Nonnull cache;           
    struct objc_protocol_list * _Nullable protocols;        
}
```

* object
```
typedef struct objc_object *id;


struct objc_object {
Class _Nonnull isa;
};

```
* 在objc中，id代表了一个对象。根据上面的声明，凡是首地址是*isa的struct指针，都可以被认为是objc中的对象。运行时可以通过isa指针，查找到该对象是属于什么类(Class)。
* 实例的isa指向了一个全局的Class, Class中记录了类名、成员变量信息、property信息、protocol信息和实例方法列表等
* Class的isa指向一个全局的meta-class，meta-class中记录类名，类方法列表等
### 继承
![avatar](/类继承.pdf)
## 消息转发
## 应用
