require 'cgi'
require 'uri'
require 'httparty'
require 'hashie'
Hash.send :include, Hashie::HashExtensions

class PhmClient
  include HTTParty
  headers 'Content-Type' => 'apilication/json'
  base_uri 'http://api.powerhousemuseum.com/api/v1'

  def initialize(api_key=nil)
    @api_key = if api_key.nil? 
      if File.exists? 'config.yaml'
        YAML.load_file('config.yaml')['phm_api_key']
      else
        ENV['phm_api_key']
      end
    else 
      api_key
    end
  end

  def subjects(name='music')
    response = PhmClient.get "/subject/json/?api_key=#{@api_key}&name=#{name}"
    Hashie::Mash.new(response).subjects
  end

  def subject(subject_id)
    response = PhmClient.get "/subject/#{subject_id}/json/?api_key=#{@api_key}"
    subject = Hashie::Mash.new(response).subject
    subject.items = items_by_subject subject_id
    subject
  end
  
  def items_by_subject(subject_id)
    response = PhmClient.get "/subject/#{subject_id}/items/json/?api_key=#{@api_key}"
    items = Hashie::Mash.new(response).items.each do |i|
      i.title = (i.title.nil? or i.title == '') ? (i.description[0,100] + "...") : i.title
    end
    items
  end

  def full_item(item_id)
    response = PhmClient.get "/item/#{item_id}/json/?api_key=#{@api_key}"
    item = Hashie::Mash.new(response).item
    item.title = (item.title.nil? or item.title == '') ? (item.description[0,100] + "...") : item.title
    unless item.num_multimedia.nil? or item.num_multimedia < 1
      response = PhmClient.get "/item/#{item_id}/multimedia/json/?api_key=#{@api_key}"
      multi = Hashie::Mash.new(response).multimedia
      item.multimedia = multi
    end
    item
  end
end
