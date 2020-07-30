require 'sinatra'
require 'sinatra/reloader'
require 'pg'

class Memo
  attr_reader :id, :title, :content
  def initialize(title, content)
    @id = id
    @title = title
    @content = content
  end
end

get '/' do
  conn = PG.connect(host: 'localhost', user: 'postgres', dbname: 'postgres')
  @results = conn.exec('SELECT * FROM memos;')
  erb :top
end

get '/new' do
  erb :new
end

post '/new' do
  memo = Memo.new(params[:title], params[:content])
  conn = PG.connect(host: 'localhost', user: 'postgres', dbname: 'postgres')
  conn.exec("INSERT INTO memos (title, content) VALUES ('#{memo.title}', '#{memo.content}')")
  redirect '/'
end

get '/memos/:id' do
  conn = PG.connect(host: 'localhost', user: 'postgres', dbname: 'postgres')
  @results = conn.exec("SELECT * FROM memos where id = #{params[:id]};")
  erb :memo
end

get '/memos/:id/edit' do
  conn = PG.connect(host: 'localhost', user: 'postgres', dbname: 'postgres')
  @results = conn.exec("SELECT * FROM memos where id = #{params[:id]};")
  erb :edit
end

patch '/memos/:id' do
  conn = PG.connect(host: 'localhost', user: 'postgres', dbname: 'postgres')
  conn.exec("UPDATE memos SET title='#{params[:title]}', content='#{params[:content]}' WHERE id=#{params[:id]};")
  redirect '/'
end

delete '/memos/:id' do
  conn = PG.connect(host: 'localhost', user: 'postgres', dbname: 'postgres')
  conn.exec("DELETE FROM memos WHERE id = #{params[:id]};")
  redirect '/'
end
