# HeyDan

Why HeyDan? I wrote it to help answer questions. Every time you have a question about governments, I imagine you turning around and saying 'Hey Dan! how many governments have x or y?''

At every civic company I've worked at, I needed to build some sort of government data munging tool set. I wrote HeyDan, partly for myself, and partly to share.

The goal is to create an easy versino controlled data import and processing tool for single variables, attributes, properties, etc and an ultra fast http server backed by ElasticSearch with extreme filter capabilities and data extendability. This is not a data catalogue, its middleware to pull data from data catalogues and process it. 

##Build Status

[![Build Status](https://travis-ci.org/danmelton/heydan.svg?branch=master)](https://travis-ci.org/danmelton/heydan)

## Installation

You will need git & ruby for the core library

    $ gem install heydan

If you would like to leverage the server & search functionality, you will need elasticsearch

    http://elastic.co/downloads

## Command Line Usage

HeyDan is meant to be used in a shell:

    $ heydan help
    #returns a list of commands you do

    $ heydan setup
    #sets up heydan in the current directory

    $ heydan build --type optional
    #creates the jurisdiction files in the jurisdictions folder

    $ heydan sources sync
    #pulls down sources into sources folder leveraging git

    $ heydan sources build 
    #builds through each source in the sources folder, optional parameters
    #include --fromsource, --type, and FOLDER NAME VARIABLE

    $ heydan sources add github_http_link.git
    #clones a source from git repo and adds to settings file under sources

    $heydan sources new FOLDER SOURCENAME VARIABLE
    #creates or adds a new variable under sources/folder/sourcename and sources/folder/scripts/sourcenamevariable.rb

    $ heydan import
    #bulk imports the jurisdictions folder into elasticsearch for extreme search goodness

    $ heydan server
    #starts a sinatra server at localhost:4567/entities

    $ heydan upload
    #uploads contents of the datasets folder to aws as specified in the settings file.


## Adding Data

You can contribute to HeyDan by creating a new source folder on github. Look at https://github.com/danmelton/heydan_sources as an example.

To create a new directory for data:

    $ heydan sources new example example_source example_variable_name

This will create a folder 'example' in sources/ with a json file name example_source and a ruby file inside example/script/example_variable_name.rb

You can update json file with metadata about the source. Each variable also has metadata too. 

The script file has three methods in it. A version, which defaults to 1; a type, which defaults to 'dataset'; and a build method with some sample code.

At the end of the build method, you should have a 2 to multiple column @data variable with the first row as headers.

You can add pry in the build method to help you troubleshoot:

      require 'pry'
      binding.pry


## Contributing

Bug reports and pull requests are welcome on [GitHub Issues](https://github.com/danmelton/heydan/issues). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

