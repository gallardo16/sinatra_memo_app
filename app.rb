require 'sinatra'
require 'sinatra/reloader'
require 'pg'

class Memo
  @@conn = PG.connect(host: ENV["HOST"], user: ENV["DBUSER"], dbname: ENV["DBNAME"], password: ENV["PASSWORD"])

  def initialize(title, content)
    @title = title
    @content = content
  end

  def self.find_all
    @@conn.exec('SELECT * FROM memos;')
  end

  def self.find_by_id(id)
    @@conn.exec("SELECT * FROM memos where id = '#{id}';")
  end

  def create
    @@conn.exec("INSERT INTO memos (title, content) VALUES ('#{@title}', '#{@content}')")
  end

  def update(id)
    @@conn.exec("UPDATE memos SET title='#{@title}', content='#{@content}' WHERE id=#{id};")
  end

  def delete(id)
    @@conn.exec("DELETE FROM memos WHERE id = #{id};")
  end
end

get '/' do
  @results = Memo.find_all
  erb :top
end

get '/new' do
  erb :new
end

post '/new' do
  memo = Memo.new(params[:title], params[:content])
  memo.create
  redirect '/'
end

get '/memos/:id' do
  @results = Memo.find_by_id(params[:id])
  erb :memo
end

get '/memos/:id/edit' do
  @results = Memo.find_by_id(params[:id])
  erb :edit
end

patch '/memos/:id' do
  memo = Memo.new(params[:title], params[:content])
  memo.update(params[:id])
  redirect '/'
end

delete '/memos/:id' do
  memo = Memo.new(params[:title], params[:content] )
  memo.delete(params[:id])
  redirect '/'
end
