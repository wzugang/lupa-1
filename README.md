![logo](https://github.com/richardhundt/lupa/wiki/lupa_logo.png)

# NAME

Lupa - multi-paradigm object oriented, dynamic language

# SYNOPSIS

    lupa <file>
        run the script
    lupa <file> -l
        list generated Lua

# INTRODUCTION

*NOTE:* This is alpha software and is therefore very likey to change

Lupa is a language which translates to Lua. So, bowing to the
mandatory justification of "why yet another language", here's the
reasoning. LuaJIT2 is fast. Very fast. I like fast in a language
runtime. LuaJIT2 also has a low memory footprint. Which is also
nice.

However, although a beautiful language, Lua is also very minimal.
I want a language with a bit more meat. More than that though, I
want a language which gives me the most syntactic and semantic
flexibility possible, while allowing me to write code which is
run-time safe. Not type safe, neccessarily, but more generally,
constraint safe, where a constraint may be a type check.

For syntactic and semantic flexibility, Lupa borrows an idea from
Scala in that infix and prefix operators are method calls. That's
probably where the similarity ends. Lupa is a dynamic language.

For safety, Lupa provides compile-time symbol checks to catch typos,
and for the rest we have guard expressions.

Lupa to Lua source translation is done without the use of abstract
syntax trees in a single pass, using essentially a big substitution
capture with LPeg. This limits static checks and early binding
across source files, but compilation is fast and within a given
compilation unit we can still perform some checks. It also allows
us to call from Lupa into Lua.

## Features

Most of Lua's semantics shine through, such as Lua's for loops,
1-based arrays, first-class functions, and late binding.

However, Lupa adds several features, such as:

* classes with single inheritance
* parameterisable traits and mixin composition
* everything-is-an-object semantics
* static symbol resolution
* type guards and assertions
* language integrated grammars (via LPeg)
* operators as method calls
* continue statement
* string interpolation
* builtin Array type
* short function literals
* switch-case statement
* try-catch statement
* and more...

# LANGUAGE

Syntactically Lupa belongs to the C family of languages, in that
it has curly braces delimiting blocks and includes familiar constructs
such as switch statements and while loops.

## Sample

```ActionScript
trait Pet[T] {
   // parameterised traits with lexical scoping
   has size : T
}
 
class Mammal {
   has blood = "warm"
}

trait Named {
   // default property values are lazy expressions
   has name = error("A pet needs a name!")
}
 
// single inheritance with trait mixins
class Hamster from Mammal with Pet[Number], Named {

   // default initializer
   method init(name) {
      self.size = 42
      .name = name // short for self.name = name
   }

   method greet(whom : String) {
      // string interpolation
      print("Hi ${whom}, I am ${.name}, a ${.size}, ${.blood}, ${typeof self}!")
   }

   // class bodies have lexical scope
   var numbers = [ "one", "two", "three", "four", "five" ]

   method count(upto) {
      // short functions
      upto.times((_) => { print(numbers[_]) })

      // same thing, but `times' as infix operator
      upto times => print(numbers[_])
   }
}
 
var rudy = Hamster.new("Rudy")
rudy.greet("Jack")
rudy.count(5)
```

## Tutorial

To introduce the language, we start with a tutorial, where we
implement a naive NumArray type which simply wraps an Array, and
constrains values to be of type Number. Our first attempt might
look as follows:

```ActionScript
class NumArray {
    // a "public" read-write property with lazy constructor
    has data = [ ]

    // initializer
    method init(data) {
        self.data = data || [ ]
    }

    method set(index, value) {
        if !value is Number {
            throw "${value} is not a Number"
        }
        self.data[index] = value
    }

    method get(index) {
        return self.data[index]
    }
}
```

This has several problems. One problem is that it doesn't
implement the same interface as the built-in Array type which
it is wrapping. Lupa provides postcircumfix operator methods
which allow us to make this more consistent:

```ActionScript
class NumArray {
    has data = [ ]
    method init(data) {
        self.data = data || [ ]
    }
    method _[]=(index, value) {
        if !value is Number {
            throw "${value} is not a Number"
        }
        self.data[index] = value
    }
    method _[](index) {
        return self.data[index]
    }
}
```

The `_[]` and `_[]=` methods are called when getting or
setting a value using array subscript.

A second thing which can make our implementation nicer is
to use guard annotations instead of explicitly checking
that our value is a `Number`.

```ActionScript
class NumArray {
    has data = [ ]
    method init(data) {
        self.data = data || [ ]
    }
    method _[]=(index, value : Number) {
        self.data[index] = value
    }
    method _[](index) {
        return self.data[index]
    }
    method len {
        self.data.len
    }
}
```

The Array class also implements a `len` property which is
readonly. Properties introduced by `has` are actually just
sugar for creating a getter/setter method pair. Therefore
to create a readonly property, simply define the method
and call it without parameters:

```ActionScript
class NumArray {
    has data = [ ]
    method init(data) {
        self.data = data || [ ]
    }
    method _[]=(index, value : Number) {
        self.data[index] = value
    }
    method _[](index) {
        return self.data[index]
    }
    method len {
        .data.len
    }
}
```

Note that the `return` keyword is missing from our `len` method.
This is because the last expression evaluated in a function
body has an implicit return. Similarly we could have left
out the `_[]` method's return.

This makes it convenient to use `map` and similar functions
for transforming list-like objects. More on that later.

We've also left out `self`, which is implied by the leading `.`.

A class body is actually a closure which can have lexical variables
which are not accessible from outside. This can be used to make our
inner array private. You could do the following:

```ActionScript
class NumArray {
    // create a table with weak keys
    var private = { } weak 'k'

    method init(data) {
        private[self] = data || [ ]
    }
    method _[]=(index, value : Number) {
        private[self][index] = value
    }
    method _[](index) {
        private[self][index]
    }
    method len {
        private[self].len
    }
}
```

It's not all that pretty, but then again, Lupa is more interested
in being flexible than carrying around a shotgun. Another thing
you could do is to use the low-level direct table access operator `#`.

This operator exists for interop with Lua and Lua libraries (and for
making hard things possible):

```ActionScript
class NumArray {
    method init(data : Array = [ ]) {
        self#data = data
    }
    method _[]=(index, value : Number) {
        self#data[index] = value
    }
    method _[](index) {
        self#data[index]
    }
    method len {
        self#data.len
    }
}
```

This is also not pretty, but it is noticeable. Which is good. The
`#` operator is associated with accessing something's private parts
in that member accesses via `.` are method calls. Names following
the `#` operator are also not mangled, which is needed for calling
into Lua and FFI code.

You could, of course, save yourself all the above trouble if you're
just interested in constraint checking and create a guard:

```ActionScript
guard NumArray(sample : Array) {
    // the Number annotation on the value does the coercion
    for index, value : Number in sample {
        // in-place, although we could return a copy
        sample[index] = value
    }
    return sample
}

var foo : NumArray = [ 1, 2, "three" ] // KABOOM! cannot coerce "three" to Number
```

Alternatively you could save yourself even that much trouble and just say:

```ActionScript
var foo : Array[Number] = [ 1, 2, 3 ]
```

This works simply because the Array class itself implements a static
method `_[]` which constructs a guard on demand and returns it.

## Scoping

Lupa has two kinds of scopes. The first is simple lexical scoping,
which is seen in function and class bodies, and control structures.

The second kind of scope is the environment scope, which is modeled
after Lua 5.2's `_ENV` idea, where symbols which are not declared in
a compilation unit, are looked up in a special `__env` table, which
delegates to Lua's `_G` global table.

At the top level of a script, class, object, trait and function
declarations are bound to `__env`, while variable declarations
remain lexical.

Inside class, object and trait bodies, only function declarations
bind to `__env`. Method and property declarations bind to `self`
(the class or object).

Inside function bodies, function declarations are lexical and are
*not* hoisted to the top of the scope, meaning they are only visible
after they are declared.

Variable declarations declared as `var` are always lexical. To declare
a variable bound to the environment, use `our`:

```ActionScript
var answer = 42  // ordinary lexical
our DEBUG = true // bound to environment
```

```ActionScript
// bound to the environment (__env.envfunc)
function envfunc() {
    // ...
}
// a lexical function
var localfunc = function() {
    // ...
}
class MyClass {
    // this function is only visible in this block
    function hidden() {
        // ...
    }
    method munge() {
        hidden()
    }
}
```

Nested function declarations are also lexical, however the differ
from function literals in that inside a function declaration, the
function itself is always visible, so can be called recursively:

```ActionScript
function outer() {

    // inner function is lexical
    function inner() {
        // inner itself is visible here
    }

    // not quite the same thing
    var inner = function() {
        // inner itself is not visible here
    }
}
```

## Variables

Lexical variables are introduced with the `var` keyword, followed
by a comma separated list of identifiers, and an optional `=`
followed by a list of expressions.

```ActionScript
var a, b         // declare only
var c, d = 1, 2  // declare and assign
```

Variables can also be introduced using the `our` keyword, which, as
mentioned earlier binds to the environment table:

```ActionScript
function life_etc() {
    print("the answer is ${answer}")
}
our answer = 42
life_etc()
```

## Guards

Various declarations may also include guard expressions:

```ActionScript
var s : String = "first"
```

Future updates to guarded variables within a given scope cause the
guard's `coerce` method to be called with the value as argument to
allow the guard to coerce the value or raise an exception.

The above statement (loosely) translates to the following Lua snippet:

```Lua
local s = String:coerce("first")
```

Classes and traits, as well as built-in types `Number`, `String`,
`Boolean`, `Array`, `Table` and `Function` can be used as guards.

Custom guards can also be created using a `guard` declaration:

```ActionScript
guard Size(sample : Number) {
    if !sample > 0 {
        throw TypeError.new("${sample} does not pass Size constraint")
    }
    return sample
}
var size : Size = 4.2
```

## Assignment

Assignments can be simple binding expressions:

```ActionScript
everything.answer = 42
```
... or compound:

```ActionScript
a += 1
```

## Operators

Most operators in Lupa are method calls. For example:

```ActionScript
a + 42
```

which is the same as:
```ActionScript
a.+(42)
```

This syntax applies to all method calls, so the following are equivalent:

```ActionScript
var d = Dog.new("Fido")
var d = Dog new "Fido"
10.times((i) => { print(i) })
10 times (i) => { print(i) }
10 times => print(_) // same as above
```

A notable exception are `===` and `!==` which are raw identity comparisons.

Infix operator precedences are determined by their first character and are
always left associative. In the order of highest to lowest precedence:

### Infix operator precedence

* alphanumeric word
* /, *, %
* +, -, ~
* :, ?
* =, !
* <, >
* ^
* &
* |

Prefix operators can also be defined as methods. The following may be used:

* @
* #
* -
* ~
* *

To define a prefix operator method, the method name must be suffixed
with an underscore. For example:
```ActionScript
class A {
    // unary minus
    method -_(b) {
        ...
    }
}
```

Additionally, postcircumfix operators are allowed in certain contexts. Array and
Table subscripts are actually defined as `_[]` and `_[]=` methods. These
can be used to implement your own collection:

```ActionScript
class NumberArray {
    has data = [ ]
    method _[](index) {
        .data[index]
    }
    method _[]=(index, value : Number) {
        .data[index] = value
    }
}
var nums = NumberArray.new
nums[1] = 42
```

Property assignment is also a bit special, in that `foo.bar = 42` translates
to `foo.bar_eq(42)`.

## Identifiers

Indentifiers in Lupa come in two flavours. The first type are the
familiar type seen in most languages (currently `?` and `!` are
supported in the first and last positions respectively). The following
pattern describes these:

```
name = / (%alpha | "_" | "$" | "?") (%alnum | "_" | "$")* "!"? /
```

Other other kind of identifiers consist only of punctuation as described
earlier under Operators. These are used in method declarations:

```ActionScript
class Point {
    has x : Number = 0
    has y : Number = 0
    method +(b : Point) : Point {
        Point.new(.x + b.x, .y + b.y)
    }
}
```

## Patterns

Lupa integrates LPeg into the language and supports pattern literals
delimited by a starting and ending `/`:

```ActionScript
var ident = / { [a-zA-Z_] ([a-zA-Z_0-9]+) } /
```

Patterns are also composable. Here the lexical pattern `a` is
referenced from within the second pattern:

```ActionScript
var a = / '42' /
print(/ { 'answer' | <{a}> } /.match("42"))
```

Grammars are constructed in that nominal types can declare patterns
as rules in their body. Here's the example macro expander from the
LPeg website translated to Lupa:

```ActionScript
object Macro {

    rule text {
        {~ <item>* ~}
    }
    rule item {
        <macro> | [^()] | '(' <item>* ')'
    }
    rule arg {
        ' '* {~ (!',' <item>)* ~}
    }
    rule args {
        '(' <arg> (',' <arg>)* ')'
    }
    rule macro {
        | ('apply' <args>) -> '%1(%2)'
        | ('add'   <args>) -> '%1 + %2'
        | ('mul'   <args>) -> '%1 * %2'
    }
}

var s = "add(mul(a,b),apply(f,x))"
print(Macro.text(s))
```

The Lupa grammar is self bootstrapped, so hopefully that can serve
as a reference until I finish this document. ;)

## Modules

Modules are simply Lupa source files. There are no additional
namespaces constructs within the language to declare modules or
packages.

Symbols are not exported by default. To export symbols, the `export`
statement can be used. It has the form `export <name> [, <name>]*`
Symbols can be imported using the `import` statement, which takes
the form `import [<name> [, <name>] from <dotted_path>`.

For example:

```ActionScript
/*--- file: ./my/shapes.lu ---*/
export Point, Point3D

class Point {
    has x = 0
    has y = 0
    method move(x, y) {
        self.x = x
        self.y = y
    }
}
class Point3D from Point {
    has z = 0
    method move(x, y, z) {
        super.move(x, y)
        self.z = z
    }
}

/*--- file: test.lu ---*/
import Point, Point3D from my.shapes

var p = Point3D.new
p.move(1, 2, 3)
```

It is an error to attempt to export a symbol which is never declared,
or is declared but evaluates to `nil`.

