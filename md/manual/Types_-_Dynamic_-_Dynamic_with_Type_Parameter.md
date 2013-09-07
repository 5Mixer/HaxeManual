`Dynamic` is a special type because it allows explicit declaration with and without a type parameter ([manual/Type_Parameters]). If such a type parameter is provided, the semantics described in [manual/Dynamic] are constrained to all fields being compatible with the parameter type:

```
var att : Dynamic<String> = xml.attributes;
att.name = "Nicolas"; // valid, value is a String
att.age = "26"; // dito (this documentation is quite old)
att.income = 0; // error, value is not a String
```