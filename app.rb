require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

class Memo
  attr_reader :id, :title, :content
  def initialize(title, content)
    @id = SecureRandom.uuid
    @title = title
    @content = content
  end
end

get '/' do
  erb :top
end

get '/new' do
  erb :new
end

post '/new' do
  memo = Memo.new(params[:title], params[:content])
  File.open("memos/#{memo.id}.json", 'w') do |file|
    hash = { id: memo.id, title: memo.title, content: memo.content }
    JSON.dump(hash, file)
  end
  redirect '/'
end

get '/memos/:id' do
  @file = File.open("./memos/#{params[:id]}.json", 'r')
  erb :memo
end

get '/memos/:id/edit' do
  @file = File.open("./memos/#{params[:id]}.json", 'r')
  erb :edit
end

patch '/memos/:id' do
  File.open("./memos/#{params[:id]}.json", 'w') do |file|
    hash = { id: params[:id], title: params[:title], content: params[:content] }
    JSON.dump(hash, file)
  end
  redirect '/'
end

delete '/memos/:id' do
  File.delete("./memos/#{params[:id]}.json")
  redirect '/'
end
