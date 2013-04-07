[![Gem Version](https://badge.fury.io/rb/s3cmd.png)](http://badge.fury.io/rb/s3cmd)
[![Dependency Status](https://gemnasium.com/samuelkadolph/s3cmd.png)](https://gemnasium.com/samuelkadolph/s3cmd)
[![Code Climate](https://codeclimate.com/github/samuelkadolph/s3cmd.png)](https://codeclimate.com/github/samuelkadolph/s3cmd)

# s3cmd

`s3cmd` is simple cli tool for interacting with S3.

## Description

Provides a `s3cmd` executable that allows you to create and list buckets as well as list the keys of a bucket and get and upload files to S3.

## Installation

Install with:

    $ gem install s3cmd

## Usage

```
s3cmd create-bucket $(USER)-foo
s3cmd put $(USER)-foo file.rb file.rb
```

## Contributing

Fork, branch & pull request.
