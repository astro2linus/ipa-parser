# IpaParser

Extract information from a ipa file

## Installation

Add this line to your application's Gemfile:

    gem 'ipa-parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ipa-parser

## Usage

ipa_file = IpaParser::IPAFile.new(/path/to/your/ipa_file)
ipa_file.name
ipa_file.display_name
ipa_file.identifier

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ipa-parser/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
