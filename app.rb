require 'rubygems'
require 'yaml'
require 'haml'
require 'sinatra'
require 'date'
require 'phm'
require 'heatmap'
require 'pp'

helpers do
  def subject_histogram(subjects)
    hist = {}
    subjects.each do |s|
      hist["<a href=\"/subject/#{s.id}\" title=\"#{s.name}\">#{s.name}</a>"] = s.num_items
    end
    hist
  end

  def subject_map(histogram)
    Heatmap.new.heatmap histogram
  end
end

get '/' do
  phm = PhmClient.new
  raw_subjects = phm.subjects.to_a.collect
  @subjects = subject_histogram raw_subjects
  haml :index
end

get '/subject/:subject_id' do
  phm = PhmClient.new
  @subject = phm.subject params[:subject_id]
  raise not_found unless @subject
  haml :subject
end

get '/item/:item_id' do
  phm = PhmClient.new
  @item = phm.full_item(params[:item_id])
  raise not_found unless @item
  haml :item
end

not_found do
  haml :not_found
end

error do
  haml :error
end