require 'yaml'
require 'octokit'

class Gist
  attr_reader :client, :config
  
  def initialize
    @config = YAML.load_file("config.yml")
    @client = Octokit::Client.new(access_token: @config['access_token'])
  end

  #Gistを作成する
  #file_name ファイル名
  #file_content ファイルの内容
  #file_description ファイルの説明
  def create_gist(file_name, file_content, file_description)
    gist_content = create_content(file_name, file_content, file_description)
    puts gist_content
    @client.create_gist(gist_content)
  end
  
  #gist一覧を取得する
  #key:gistid,value:filenameのhashのリストを返す
  def gist_list
    gists = @client.gists(config['account_name'])
    gist_list = []
    gists.each do |gist|
      hash = {}
      hash[gist.id] = gist.files.first.first
      gist_list << hash
    end
    return gist_list
  end

  #gistを編集する
  #id 編集するgistのid
  #file_name ファイル名
  #file_content ファイルの内容
  #file_description ファイルの説明
  def edit_gist(id, file_name, file_content, file_description)
    file = create_content(file_name, file_content, file_description)
    @client.edit_gist(id, file)
  end

  private
  # Gistを作成するすためのhashを作成する
  def create_content(name, content, description)
    gist_content = {}
    gist_content["description"] = description
    gist_content["public"] = @config["public"]
    file_content = {}
    file_content["content"] = content
    file = {}
    file[name] = file_content
    gist_content["files"] = file
    return gist_content
  end
end