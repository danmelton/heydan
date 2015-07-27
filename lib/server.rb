require 'sinatra'
require 'json'
require 'sinatra/cross_origin'
require 'elasticsearch'

class HeyDan::Server < Sinatra::Base
  configure do
    enable :cross_origin
  end

  get '/entities/types' do
    content_type 'application/json'
    file = File.join(Dir.pwd, 'jurisdictions', '*')
    types = Dir[file].map { |x| x.split('/')[-1]}
    {types: types}.to_json
  end

  get '/entities/*.json' do
    content_type 'application/json'
    begin
    file = File.join(Dir.pwd, 'jurisdictions', "#{params[:splat][0].gsub('/','::')}.json")
    File.read(file)
    rescue
      halt 404, "{\"message\": \"I couldn\'t find #{params[:splat][0]}. Is the ID right?\"}"
    end
  end

  get '/entities' do
    content_type 'application/json'
    begin
      client = Elasticsearch::Client.new log: false
      r = client.search index: 'jurisdictions',type: params[:type], :_source_include => ['id', 'entityType', 'name', 'entityUrl'],
                  body: {
                    from: params[:page] || 1,
                    size: params[:per_page] || 10
                  }
       return {total: r["hits"]["total"], page: params[:page] || 1, entities: r["hits"]["hits"].map { |x| x["_source"]}}.to_json
    rescue
      halt 404, '{"message": "Hrmm, something is fishy here. Are you do something weird?"}'
    end
  end

  get '/entities/*' do
    content_type 'application/json'
    begin
      client = Elasticsearch::Client.new log: false
      r = client.search index: 'jurisdictions', type: params[:type], :_source_include => ['id', 'entityType', 'name', 'entityUrl'],
                  body: {
                    query: {
                      simple_query_string:{query: "\"#{params[:splat][0]}*\"", fields: ['id']}
                    },
                    from: params[:page] || 1,
                    size: params[:per_page] || 10
                  }
                  return {total: r["hits"]["total"], page: params[:page] || 1, entities: r["hits"]["hits"].map { |x| x["_source"]}}.to_json
    rescue
      halt 404, '{"message": "Hrmm, something is fishy here. Are you do something weird?"}'
    end
  end
end