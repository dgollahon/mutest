mutest
======
[![Build status](https://badge.buildkite.com/8b58446082c5724c4e37e7fa4a4e0d5ee04b936b95a744c3cf.svg?branch=master&style=flat-square)](https://buildkite.com/rubocop-rspec/mutest)

`mutest` is a mutation testing tool for ruby designed to help audit the thoroughness of your test suite and encourage you to write more robust code.

## How it works

`mutest` parses your ruby code, inserts modifications, and then runs your test suite. If your test suite still _passes_ after `mutest` has mutated your code, you have an _alive_ mutation--meaning your tests do not thoroughly cover the modified part of your code. If your tests _fail_ after the code has been modified, the mutation is _killed_. This means that your test suite was able to detect the semantic change and provide adequate coverage of that condition.

For full examples and a more detailed explanation of the technique, check out this [blog post](https://blog.blockscore.com/how-to-write-better-code-using-mutation-testing/).

## Installation

`mutest` is currently only compatible with `rspec`. To install the `rspec` integration, run:

```shell
$ gem install mutest-rspec
```

or add

```ruby
gem 'mutest-rspec'
```

to your Gemfile.

## Usage

###### Run `mutest` on the entire MyProject namespace
`mutest --include lib --require my_project --use rspec 'MyProject*'`

###### Run `mutest` on a specific class
`mutest --include lib --require my_project --use rspec 'MyProject::Foo'`

###### Run `mutest` on a specific class method
`mutest --include lib --require my_project --use rspec 'MyProject::Foo.bar'`

###### Run `mutest` on a specific instance method
`mutest --include lib --require my_project --use rspec 'MyProject::Foo#bar'`

###### Run `mutest` on only the changes inside the MyProject namespace since a git revision
`mutest --include lib --require my_project --use rspec --since HEAD~1 'MyProject*'`

## Changes

For updates to the project, check out the [CHANGELOG](CHANGELOG.md)!

## Credit

* Markus Schirp did an amazing job on [mutant](https://github.com/mbj/mutant) which this fork is based on.
