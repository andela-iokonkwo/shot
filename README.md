Shot
====

## Introduction

Template engines are things of all days. And this days most of them have several hundred (erb) if not thousand (erubis) of lines of code, even slim isn't so slim. So, `shot` was written with the requirements of be simple and easy to use.

## Installation

Installing shot is as simple as running:

```
$ gem install shot
```

Include shot in your Gemfile with gem 'shot' or require it with require 'shot'.

Usage
-----

Is very similar than other template engines for Ruby as Liquid, Mote, etc:

```ruby
template = Shot::Template.new("Hello World")
template.render #=> "Hello World"
```

## Ruby code

Lines that start with `@` are evaluated as Ruby code.

```
@if true
  Hi
@else
  No, I won't display me
@end
```

As this is ruby code, you can comment as you has always done.

```
@ # I'm a comment.
```

And you can still doing any ruby thing: blocks, loops, etc.

```
@ 3.times do |i|
    {{i}}
@ end
```

## Variables

To print a variable just use `{{` and `}}`

Send a variables as a hash in the parse method to the template so it can get them:

```ruby
template = Shot::Template.new("Hello, this is {{user}}")
template.render user: "dog" #=> "Hello, this is dog"
```

Also, you can send other kinds of variables:

```ruby
template = <<-EOT
  @ items.each do |item|
      {{ item }}
  @ end
EOT
parsed = Shot::Template.new(template, items: ["a", "b", "c"])
parsed.render #=> "a\nb\n\c"
```

You can even take advantage of do whatever operation inside the `{{ }}`

```ruby
template = Shot::Template.new("The new price is: {{ price + 10 }}")
template.render price: 30 #=> "The new price is: 40"
```

## Scopes

For send a particular context to your template, use the key `context` and your methods and variables will be called inside of your sent context.

```ruby
class User
  def name
    "Julio"
  end
end

template = Shot::Template.new("Hi, I'm {{ name }}", scope: User.new)
template.render #=> "Hi, I'm Julio"
```

## Templates

In order to use shot in a file template, use the suffix `.shot`, e.g. `public/index.html.shot` and add the path of your view when initializing the template engine. Feel free to use any markup language as HTML.

```html
<!-- public/index.html.ate -->
<body>
  <h1>{{ title }}</h1>
  @ posts.each do |post|
    <article>...</article>
  @ end
</body>
```

```ruby
template = Shot::Template.new("public/index.html.ate")
template.render  title: "h1 title!", posts: array_of_posts
```