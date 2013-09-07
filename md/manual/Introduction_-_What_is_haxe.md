Haxe is a high-level language programming language and compiler for that language. It allows compilation of programs written using an ECMAScript-oriented syntax to multiple target languages. Employing proper abstraction, it it is possible to maintain a single code-base which compiles to multiple targets.

Haxe is strongly typed, but the typing system can be subverted where required. Utilizing type information, the Haxe type system can detect during compilation errors that in the target language would only be noticable at runtime. Furthermore, type information can be used by the target generators to generate optimized and robust code.

There are currently nine supported target languages which allow different use-cases:




Name & Output type & Main usages 
 
Javascript & Sourcecode & Desktop, Mobile, Server 

Actionscript 3 & Sourcecode & Browser, Desktop, Mobile 

Flash 6-8 & Bytecode & Browser 

Flash 9+ & Bytecode & Browser, Desktop, Mobile 
 
Neko & Bytecode & Desktop, Server 

PHP & Sourcecode & Server 

C++ & Sourcecode & Desktop, Mobile, Server 

Java & Sourcecode & Desktop, Server 

C# & Sourcecode & Desktop, Mobile, Server 
 


The remainder of section [manual/Introduction] gives a brief overview of what a haxe program looks like, and how haxe has developed since its inception in 2005.

[manual/Types] introduces the seven kinds of types in haxe and how they interact with each other. Type discussion is continued in [manual/Type_System], where features such as **unification**, **type parameters** and **type inference** are explained.

[manual/Class_Fields] is all about the structure of haxe classes and, among other topics, deals with **properties**, **inline fields** and **generic functions**.

In [manual/Expressions] we see how to actually get programs to do something by using **expressions**, plenty of which are used in the Haxe Standard Library described in [manual/Standard_Library].

[manual/Miscallaneous_Features] describes some of the haxe features in detail, such as **pattern matching**, **string interpolation** and **dead code elimination**.

Finally, we will venture to the exciting land of **haxe macros** in [manual/Macros] to see how some common tasks can be simplified greatly.