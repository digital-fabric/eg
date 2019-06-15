# EG - Prototype based objects for Ruby

[INSTALL](#installing-eg) |
[USAGE](#using-eg)

## What is EG

EG is a small gem that lets you create objects based on a prototype instead of a
class definition. Eg is useful for creating singletons, mockups, service or
factory objects, or simply for writing simple scripts without resorting to the
`class MyClass; ...; end; my_object = MyClass.new` dance.

```ruby
require 'eg'

greeter = EG.(
  greet: -> (name) { puts "Hello, #{name}!" }
)

greeter.greet('world')
```

## Installing EG

```bash
$ gem install eg
```

Or add it to your Gemfile, you know the drill.

## Using EG

The EG module is a callable that accepts a single hash argument containing
method prototypes and constant definitions. You can define methods, constants
and instance variables:

```ruby
o = EG.(
  foo:    -> { @bar },
  '@bar': :baz,
  VALUE:  42
)

o.foo    #=> :baz
o::VALUE #=> 42
```

### Defining methods

Any prototype key that does not begin with an upper-case letter or `@` is
considered a method. If the value is a proc or responds to `#to_proc`, it will
be used as the method body. Otherwise, EG will wrap the value in a proc that
returns it:

```ruby
o = EG.(
  foo: -> { :bar },
  bar: :baz
)

o.foo #=> :bar
o.bar #=> :baz
```

### Defining constants

Constants are defined using keys that begin with an upper-case letter:

```ruby
o = EG.(
  AnswerToEverything: 42
)

o::AnswerToEverything #=> 42
```

Care should be taken to always qualify constants when accessing them from
prototype methods by prefixing them with `self::`:

```ruby
o = EG.(
  A: 1,
  a: ->(x) { self::A + x }
)

o.a(2) #=> 3
```

### Defining instance variables

Instance variables are defined using keys that begin with an `@`:

```ruby
o = EG.(
  '@count': 0,
  incr: -> { @count += 1 }
)

o.incr #=> 1
o.incr #=> 2
```
