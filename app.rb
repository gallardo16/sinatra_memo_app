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
    sql = 'SELECT * FROM memos where id=$1;'
    result = @@conn.exec(sql, [id])
    if (record = result[0])
      Memo.new(record['title'], record['content'], record['id'])
    end
  end

  def create
    sql = 'INSERT INTO memos (title, content) VALUES ($1, $2);'
    @@conn.exec(sql, [title, content])
  end

  def update(title, content)
    sql = 'UPDATE memos SET title=$1, content=$2 WHERE id=$3;'
    @@conn.exec(sql, [title, content, id])
  end

  def delete
    sql = 'DELETE FROM memos WHERE id=$1;'
    @@conn.exec(sql, [id])
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
