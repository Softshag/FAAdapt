FAAdapt
=======

Object mapper for objective-c


## Map Dictionary 

**JSON** 

```javascript
{
  "first_name" : "Billy",
  "addr": {
    "street": "...",
    "city": ....
  }
}

```

**Object**

```objective-c

@interface Person {

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Address *address;

}


```

**Adapt!**
```objective-c

FAObjectDescription *desc = AdaptObject(Person.class, @{
  @"first_name" : @"name",
  @"addr": AdaptObject(Address.class, nil).mapUndefined(YES).map(@"address")
});

```
