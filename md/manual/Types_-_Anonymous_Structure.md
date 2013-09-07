Anonymous structures can be used to group data without explicitly creating a type. The following example creates a structure with two fields `x` and `name`, and initializes their values to `12` and `"foo"` respectively:

```
class Structure {
	static public function main() {
		var myStructure = { x: 12, name: "foo"};
	}
}
```
The general syntactic rules follow:



1. A structure is enclosed in curly braces `${}$` and
2. has a **comma-separated** list of
3. key-value-pairs, with a **double dot** separating the
4. key, which must be a valid haxe field-name, from the
5. value, which can be any valid expression.


Rule [manual/Anonymous_Structure] implies that structures can be nested and complex, e.g.:

```
var user = {
    name : "Nicolas",
    age : 32,
    pos : [{ x : 0, y : 0 },{ x : 1, y : -1 }],
};
```
Fields of structures, like classes, are accessed using a **dot** (`.`) like so:

```
user.name; // get value of name, which is "Nicolas"
user.age = 33; // set value of age to 33
```
It is worth noting that using anonymous structures does not subvert the typing system. The compiler ensures that only available fields are accessed, which means the following program does not compile:

```
class Test {
	static public function main() {
		var point = { x: 0.0, y: 12.0};
		point.z; // { y : Float, x : Float } has no field z
	}
}
```
The error message indicates that the compiler knows the type of `point`: It is a structure with fields `x` and `y` of type `Float`, so it has no field `z` and the access fails.
The fact that type of `point` is known is courtesy of [manual/Type_Inference], which thankfully saves us from using explicit types for local variables. However, if `point` was a field, explicit typing would be necessary:

```
class Path {
    var start : { x : Int, y : Int };
    var target : { x : Int, y : Int };
    var current : { x : Int, y : Int };
}
```
To avoid this kind of redundant type declaration, especially for more complex structures, it is advised to use a [manual/Typedef]:

```
typedef Point = { x : Int, y : Int }

class Path {
    var start : Point;
    var target : Point;
    var current : Point;
}
```