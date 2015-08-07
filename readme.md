#HeyDan

Why HeyDan? I wrote it to help answer questions. Every time you have a question about governments, I imagine you turning around and saying 'Hey Dan! how many governments have x or y?''

The goal is to create an ultra fast http server backed by ElasticSearch with extreme filter capabilities and data extendability. This is not a data catalogue. 

##Using heydan

After you install heydan, you can run:

      heydan sync 
      #Downloads all data sets from the CDN & imports them into elasticsearch. 

      heydan server
      #starts up the webserver for heydan

      heydan download
      #Downloads all datasets from the CDN

      heydan setup
      #Setups the identifier files in jurisdictions folder

      heydan process
      #Grab all datasets from original source process them and output into downloads folder. Mostly used to test original download.

      heydan import
      #Bulk updates elasticsearch from the jurisdictions folder

      heydan list
      #Output a nicely formatted list of names

      heydan upload
      #uploads download folder to s3. If you have a heydan.yml file with keys, it will upload all the files to an s3 bucket 

      heydan new name
      #generates new files to add a new dataset datasets/name.json, scripts/name.rb 
      
##Installing heydan

On Mac or Linux, in Terminal.app or your favorite shell:

Clone this repo:

    git clone https://git@github.com/danmelton/heydan.git

Install ElasticSearch (via homebrew):

      brew install elasticsearch #mac 1.6 or greater

Verify a ruby installation of 1.9.3 or greater:

      ruby --version      
      #ruby 2.1.4p265 (2014-10-27 revision 48166) [x86_64-darwin14.0]

Install bundler:

      gem install bundler

Install the Ruby Gem dependencies:

      bundle install
      #will install all the necessary dependencies from the Gemfile

Add heydan to your path (update the path for your compter):

      PATH= $PATH:$HOME/projects/heydan1

Copy over settings.yml.example to settings.yml

      cp settings.yml.example settings.yml

##Adding new Datasets to heydan

Adding a new dataset to hey dan is super simple. First, create two new files:

      heydan new your_data_set_name

This will create two new files, one in datasets/your_name.json and one in scripts/your_name.rb

You should name it by the source and variable. Like decennial_census_total_population. Use underscores for spaces. Each dataset is a single variable that can span multiple years. I.e. We want to add Total Population for the Decennial Census for all years available (1990 to 2010).

Inside the datasets/your_name.json, updated the following fields:

      name: A short descriptive variable name like Total Population
      description: Add any description from the source
      source: A short descriptive name for the entity 
      sourceUrl: a Link to a page where the data is hosted or explained
      period: Year, Quarter, Month, Day, 10 Years
      dates: [2010, 2011, 2013] - an array of dates for the available data
      id: choose from ansi_id or open_civic_id (we're getting other identifiers in)

Inside the scripts/your_name.rb, there are three main methods:

      class YourName < HeyDan::Process

        def get_data
        #this method is used to connect to a source, like an api, ftp or download a csv, and then saves it into the tmp folder.
          super
        end

        def transform_data
        #this method can transform data, like, pulling in data from another file and computing new data like trends, sums, etc. 
        #note, you don't need to do anything here if you don't want to process any data
          super
        end

        def save_data
        #this method saves the file into downloads
          super
        end

        def process_data
        #this method loops through each item and saves it to the jurisdictions/entity_id 
          super
        end

      end

##Folder Layout

###/datasets
A set of json

###/scripts
Contains the code to process datasets

###/jurisdictions
Contains the json files for jurisdictions, split out by folders for type. This will be populated when you run heydan sync

###server.rb
A light weight sinatra server that wraps routes to data

##Server Routes

When you run heydan start, a lightweight sinatra server will start up. The following routes are available:

/entities?per_page=100&page=1
Returns a list of entities

/entities/types
Returns a list of types

/entities/ocd-division/country:us.format
Returns a entity information

/entities/us
Returns entities contained by /us

/entities/filter 
Routes to elastic search /_search

/stats
Outputs all known data points by type and % penetration

#Open Civic Identifiers
The core of this project is the Open Data Civic IDs sponsored by Google and Sunlight Foundation
https://github.com/opencivicdata/ocd-division-ids/blob/master/identifiers/country-us.csv?raw=true. The Open Data project creates a canonical id for every jurisdiction in the world. It leverages a combination of type and name spacing based upon political or jurisidction boundaries. I.e. country:us/state:ca, or type:id/type:id. This lends itself really well to nested ids AND restful web addresses.

#Contributing

I welcome contributions! If you'd like to add a new dataset or help improve the code, please do. 

##Request a Dataset

Want a dataset in heydan? [You can add the request here](https://github.com/danmelton/heydan/labels/new%20dataset)

Label your the ticket as new dataset, title it: New Dataset: Dataset Name
and then in the description, add the url where it is at, the variables you'd like to see in heydan.

##Add a Dataset

Take a look at the roadmap, and [find a dataset request](https://github.com/danmelton/heydan/labels/new%20dataset).

Fork the project and install locally (instructions above)

Start a new dataset in the develop branch:

    git checkout develop
    heydan new dataset_name
    #add code scripts/dataset_name.rb and properties to datasets/dataset_name.json

    #verify that it works locally:
    heydan process dataset_name
    heydan import dataset_name

Then add your changes to git, and submit a pull request. Bous points for referencing the issue number in your message for the pull request: Fixes #1 

You rock!
