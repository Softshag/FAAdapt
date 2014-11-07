FAAdapt
=======

Object mapper for objective-c


## Map Dictionary 

```objective-c

FAObjectDescription *desc = AdaptObject(Person.class, @{
  @"first_name" : @"firstNameProperty",
  @"address": AdaptObject(Address.class,nil, @{
    ....
  })
});


```
