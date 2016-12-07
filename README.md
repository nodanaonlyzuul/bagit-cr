# bagit-cr

This is a [bagit](https://en.wikipedia.org/wiki/BagIt) validator.

It's not ready for production but I am using this project
to get acquainted with the [crystal programming language](crystal-lang.org).

## Building

* [Install the crystal compiler](https://crystal-lang.org/docs/installation/index.html).

* clone this repository and build with `crystal build --release src/bagit_validator.cr` from the project's root. This will output the executable `bagit_validator`.

## Usage

```
$ ./bagit_validator ~/Desktop/good_bag
This bag is valid

$ ./bagit_validator ~/Desktop/bag-with-bad-checksum
This bag is not valid:malformed checksum for: picard.jpeg

$ ./bagit_validator ~Desktop/bag-with-stranger-in-manifest
This bag is not valid:manifest lists file not contained in bag: imnothere.jpg
```

## Contributing (please)

1. Fork it (https://github.com/nodanaonlyzuul/bagit-cr/fork)
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

Please write tests to backup your work.

## Contributors

- [nodanaonlyzuul](https://github.com/nodanaonlyzuul) - creator, maintainer

## Acknowledgements

This is based on the Ruby gem [tipr/bagit](https://github.com/tipr/bagit).
I am just trying to see how fast a crystal implementation will validate compared to Ruby's.
