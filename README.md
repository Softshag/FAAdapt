FAAdapt
=======

Object mapper for objective-c


## Map Dictionary 
```javascript
{
  "first_name" : "Billy",
  "addr": {
    "street": "...",
    "city": ....
  }
}

```


```objective-c

FAObjectDescription *desc = AdaptObject(Person.class, @{
  @"first_name" : @"firstNameProperty",
  @"addr": AdaptObject(Address.class, nil).mapUndefined(YES).map(@"address")
});

```
