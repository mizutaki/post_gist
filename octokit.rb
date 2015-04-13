require 'octokit'
require 'yaml'

# 一つのGistを表すクラス
class Gist
  attr_reader :file_name, :file_content, :description, :public
  def initialize(file_name, file_content, description, public)
    @file_name = file_name
    @file_content = file_content
    @description = description
    @public  = public
  end

  # Gistを作成するすためのhashを作成する
  def create_content
    gist_content = {}
    gist_content["description"] = @description
    gist_content["public"] = @public
    file_content = {}
    file_content["content"] = @file_content
    file = {}
    file[@file_name] = file_content
    gist_content["files"] = file
    return gist_content
  end
end

#実行パス配下の拡張子が.rbファイルの名前を取得
file_names = []
Dir.entries(".").each do |file|
  file_names << file if file != __FILE__ && File.extname(file) == '.rb'
end

#octokit初期化
config = YAML.load_file("config.yml")
cl = Octokit::Client.new(access_token: config['access_token'])

gist_list = []
file_names.each do |file_name|
  File.open(file_name, 'r') do |file|
    gist = Gist.new(file.path, file.read, config["description"], config["public"])
    gist_list << gist.create_content
  end
end

gist_list.each do |gist|
  cl.create_gist(gist)
end