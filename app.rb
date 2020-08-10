require 'sinatra'
require 'sinatra/reloader'
require 'pg'

class Memo
  @@conn = PG.connect(host: ENV["HOST"], user: ENV["DBUSER"], dbname: ENV["DBNAME"], password: ENV["PASSWORD"])

  attr_reader :title, :content, :id
  def initialize(title, content, id)
    @title = title
    @content = content
    @id = id
  end

  def self.find_all
    results = @@conn.exec('SELECT * FROM memos;')
    results.map do |result|
      Memo.new(result['title'], result['content'], result['id'])
    end
  end

  def self.find_by_id(id)
    result = @@conn.exec("SELECT * FROM memos where id='#{id}';")
    Memo.new(result[0]['title'], result[0]['content'], result[0]['id'])
  end

  def create
    @@conn.exec("INSERT INTO memos (title, content) VALUES ('#{@title}', '#{@content}')")
  end

  def update(title, content)
    @@conn.exec("UPDATE memos SET title='#{title}', content='#{content}' WHERE id='#{id}';")
  end

  def delete
    @@conn.exec("DELETE FROM memos WHERE id='#{id}';")
  end
end

get '/' do
  @memos = Memo.find_all
  erb :top
end

get '/new' do
  erb :new
end

post '/new' do
  memo = Memo.new(params[:title], params[:content], params[:id])
  memo.create
  redirect '/'
end

get '/memos/:id' do
  @memo = Memo.find_by_id(params[:id])
  erb :memo
end

get '/memos/:id/edit' do
  @memo = Memo.find_by_id(params[:id])
  erb :edit
end

patch '/memos/:id' do
  memo = Memo.find_by_id(params[:id])
  memo.update(params[:title], params[:content])
  redirect '/'
end

delete '/memos/:id' do
  memo = Memo.find_by_id(params[:id])
  memo.delete
  redirect '/'
end
