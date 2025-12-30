# Changelog

## 0.5.2 - 2025-12-30

### Fixed

* Add support for ENUM return types in GraphQL operations

## 0.5.1 - 2025-03-11

### Fixed

* Add support for NON_NULL GraphQL types

## 0.5.0 - 2024-10-01

### Changed

* Remove support for Elixir 1.13. Minimum is now 1.14

## 0.4.3 - 2024-09-27

### Fixed

* Fixes where NonNull and ListTypes were defaulting to scalar types for anchor links

## 0.4.2 - 2024-09-26

### Fixed

* Links to union return types handled correctly

## 0.4.1 - 2024-09-25

### Fixed

* Links to types from queries/mutations sets anchor properly

## 0.4.0 - 2024-08-26

### Added

* Added support for Subscriptions

## 0.3.1 - 2024-07-01

### Fixed

* Fix problems with generating example queries and mutations when the return types are unions, interfaces or lists: [#49](https://github.com/podium/graphql_markdown/pull/49)

## 0.3.0 - 2024-06-25 [RETIRED]

### Added

* Support generating example queries from the schema

## 0.2.1 - 2024-03-26

### Changed

* Improve documentation
* Fix generating multiple times

## 0.2.0 - 2024-01-12

### Changed

* Deps Update release

## 0.1.5 - 2023-08-16

### Changed

* Added more documentation
* Fix typespec

## 0.1.4 - 2022-09-27

### Changed

* Update dependencies
## 0.1.3 - 2021-09-23

### Fixed

* Add missing type and description for mutations and queries

## 0.1.2 - 2021-09-17

### Fixed

* Support for Unions properly
* Fix breakage when description is nil
## 0.1.1 - 2021-09-17

### Fixed

* Fix wrong link in multi page for scalar/objects
## 0.1 - 2021-09-17

_Initial release_
