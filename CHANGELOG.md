# Change log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/).

## [Master (Unreleased)]

## [0.0.5] - 2017-03-04

### Added

- Now `mutest` can be run without being in the bundle. [[#46](https://github.com/backus/mutest/pull/46/files) ([@mvz][])]

## [0.0.4] - 2017-02-16

### Fixed

- Restarg body mutations that were being emitted for unused restargs [[#44](https://github.com/backus/mutest/pull/44/files) ([@dgollahon][])]

### Removed

- Less strict relational operator mutations (`<` -> `<=`; `>` -> `>=`) [[#47](https://github.com/backus/mutest/pull/47/files) ([@backus][])]
- Unused `ffi` dependency [[#40](https://github.com/backus/mutest/pull/40/files) ([@mvz][])]

## [0.0.3] - 2017-01-31

### Fixed

- Errors on AST nodes without locations [[#32](https://github.com/backus/mutest/pull/32/files) ([@backus][])]

## [0.0.2] - 2017-01-30

First proper RubyGems release

### Added

- Hash hint mutation (`def foo(opts); end` -> `def foo(**opts); end`) [[#24](https://github.com/backus/mutest/pull/24/files) ([@dgollahon][])]
- Unused restarg mutations (`def(*args); end` -> `def(*_args); end`; `def(**opts); end` -> `def(**_opts); end` [[#18](https://github.com/backus/mutest/pull/18/files) ([@dgollahon][])]
- Select/Reject mutations (`a.select(&b)` -> `a.reject(&b)`, `a.reject(&b)` -> `a.select(&b)`) [[#15](https://github.com/backus/mutest/pull/15/files) ([@dgollahon][])]
- Array to array literal mutation (`Array(a)` -> `[a]`) [[#14](https://github.com/backus/mutest/pull/14/files) ([@dgollahon][])]
- One-or-more to two-or-more quantifier mutations (`/a+/`  -> `/a{2,}/`; `/a+?/` -> `/a{2,}?/`; `/a++/` -> `/a{2,}+/`) [[#13](https://github.com/backus/mutest/pull/13/files) ([@dgollahon][])]
- Reluctant and possessive zero-or-more to one-or-more quantifier mutations (`/a*?/` -> `/a+?/`; `/a+?/` -> `/a++/`) [[#11](https://github.com/backus/mutest/pull/11/files) ([@dgollahon][])]
- Grep/Grepv mutations (`a.grep(b)` -> `a.grep_v(b)`; `a.grep_v(b)` -> `a.grep(b)`) [[#10](https://github.com/backus/mutest/pull/10/files) ([@dgollahon][])]
- Threequals to kind_of mutation (`a === b` -> `a.kind_of?(b)`) [[#9](https://github.com/backus/mutest/pull/9) ([@dgollahon][])]
- Method body to super mutation (`def foo; body; end` -> `def foo; super; end`) [[#8](https://github.com/backus/mutest/pull/8/files) ([@dgollahon][])]
- Mutest disables (`# mutest:disable`) [[#6](https://github.com/backus/mutest/pull/6/files) ([@backus][])]
- Compound assignment mutations (`a += b` -> `a + b`, `a = b`) [[#2](https://github.com/backus/mutest/pull/2/files) ([@dgollahon][])]

<!-- Version diffs -->

[Master (Unreleased)]: https://github.com/backus/mutest/compare/v0.0.5...HEAD
[0.0.5]: https://github.com/backus/mutest/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/backus/mutest/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/backus/mutest/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/backus/mutest/compare/7a50870929325127db8578ade9c8656f356131ba...v0.0.2

<!-- Contributors -->

[@backus]: https://github.com/backus
[@dgollahon]: https://github.com/dgollahon
[@mvz]: https://github.com/mvz
