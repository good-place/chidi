<div style="width: 100%; display: flex; justify-content: center;">
  <img alt="Hi. I am Chidi, your soulmate." src="chidi.png" />
</div>

# chidi

## Motivation

To create and maintain framework for real-time applicaitons and REST APIs akin
to [Feathers] with the help of [Janet] programming language. 

At the begining it will be only backend story. There will be no generators
(cause macros).

## Usage

You need to have [Janet] language and all dependencies installed. Then you can
just run `./chd`. For now only home with basic message and not found page,
are implemented. Also only 'application/json' content-type is accepted by the
server.

## Tests

To run tests, first run test server with `./test-chidi` then with `jpm test`.

## TODO
- [ ] minimal working example
  - [x] circlet server
  - [x] json only services
  - [x] sqlite storage
  - [ ] all usable http verbs

[Janet]: https://janet-lang.org/index.html
[Feathers]: https://feathersjs.com/
