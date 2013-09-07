This document is the official manual of haxe 3. As such, it is not a beginner's tutorial and does not teach programming. However, the topics are roughly designed to be read in order and there are references to topics "previously seen" and topics "yet to come". In some cases, an earlier section makes use of the information of a later section if it simplifies the explanation. These references are linked accordingly and in general it should not be a problem to read ahead on other topics.

We use a lot of haxe source code to keep a practical connection of theoretical matters. These code examples are often complete programs that come with a main function and can be compiled as-is. However, sometimes only the most important parts are shown.
Source code looks like this:

```
haxe code here
```
Occasionally, we demonstrate how certain haxe code is generated, for which we usually show the Javascript target.

Furthermore, we define a set of terms in this document. This is mostly done when introducing a new type, or when a term is specific to haxe. We do not define every new aspect we introduce, e.g. what a class or a class field is, in order to not clutter the text. A definition looks like this:
> Define: Name

>
> Description

In a few places, this document has **trivia**-boxes. These include off-the-record information such as why certain decisions were made while developing haxe, or how a particular feature has changed in past haxe versions. This information is generally not important and can be skipped, it is only meant to convey trivia:

> Trivia: About Trivia
>
> This is trivia.