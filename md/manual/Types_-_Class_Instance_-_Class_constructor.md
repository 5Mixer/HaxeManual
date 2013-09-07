Instances of classes are created by calling the class constructor, a process commonly referred to as **instantiation**. Another name for class instances is **object**, but we prefer the term class instance to emphasize the analogy between classes/class instances and enums/enum instances ([[manual/Enum_Instance]]). 

```
var p = new Point(-1, 65);
```
This will yield an instance of class `Point`, which is assigned to a variable named `p`. The constructor of `Point` receives the two arguments `-1` and `65` and assigns them to the instance variables `x` and `y` respectively (compare its definition in [[manual/Class_Instance]]). We will revisit the exact meaning of the new-expression later in section [[manual/new]], for now we just consider it calling the class constructor and returning the appropriate object.