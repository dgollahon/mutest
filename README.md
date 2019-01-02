mutest
======
[![Build status](https://badge.buildkite.com/8b58446082c5724c4e37e7fa4a4e0d5ee04b936b95a744c3cf.svg?branch=master&style=flat-square)](https://buildkite.com/rubocop-rspec/mutest)

`mutest` is a mutation testing tool for ruby designed to help audit the thoroughness of your test suite and encourage you to write more robust code.

## Relationship to `mutant`

`mutest` is a fork of the [mutant](https://github.com/mbj/mutant) project with a few minor additions. There are a handful of mutations which have been added, removed, or altered (see the [CHANGELOG](CHANGELOG.md) for details) as well as an inline disable comment system. This means that `mutest` allows you to do something like this:

```ruby
# mutest:disable
dont_mutate(me: true) # This line is not mutated because of the significant comment above.
mutate(me: true) # This line would continue to be mutated.
```

The `mutant` project, however, only allows disabling mutations on the method selector level and these subjects must be passed as a command line argument to the `mutant` executable.

Otherwise, `mutest` project is effectively identical to `mutant`, which is the brainchild and excellent work of [Markus Schirp](https://github.com/mbj).

###### Note: Referring to the mutant documentation may be helpful for using `mutest`, as it is generally applicable.

## How it works

`mutest` parses your ruby code, inserts modifications, and then runs your test suite. If your test suite still _passes_ after `mutest` has mutated your code, you have an _alive_ mutation--meaning your tests do not thoroughly cover the modified part of your code. If your tests _fail_ after the code has been modified, the mutation is _killed_. This means that your test suite was able to detect the semantic change and provide adequate coverage of that condition.

For full examples and a more detailed explanation of the technique, check out this [blog post](https://blog.blockscore.com/how-to-write-better-code-using-mutation-testing/).

## Installation

`mutest` is compatible with `rspec` and `minitest`. Integrations are provided
by the `mutest-rspec` and `mutest-minitest` gems, respectively. For example, to
install the `rspec` integration, run:

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

To use the `minitest` integration instead, pass `--use minitest`.

## Changes

For updates to the project, check out the [CHANGELOG](CHANGELOG.md)!

## Credit

* Markus Schirp did an amazing job on [mutant](https://github.com/mbj/mutant) which this fork is based on.
* The `minitest` integration was originally sponsored by [Arkency](https://arkency.com/).
