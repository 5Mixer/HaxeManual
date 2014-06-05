## 10.3.5 Map

The `map` method of a regular expression object can be used to replace matched substrings using a custom function:

```haxe
class Main {
  static function main() {
    var r = ~/world/;
    var s = "Hello, world!";
    var s2 = r.map(s, function(r) {
    return "Haxe";
    });
  trace(s2); // Hello, Haxe!
  }
}

```

This function takes a regular expression object as its first argument so we may use it to get additional information about the match being done.

---

Previous section: [Split](std-regex-split.md)

Next section: [Implementation Details](std-regex-implementation-details.md)

Contribute: [fileAndLines](https://github.com/HaxeFoundation/HaxeManual/blob/master/10-std.tex#L230-230)