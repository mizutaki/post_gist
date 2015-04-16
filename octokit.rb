require 'octokit'
require 'yaml'
require 'fileutils'
require 'logger'

#Loggerの設定
FileUtils.mkdir('log') unless File.exists?('./log')
logger = Logger.new('./log/octokit.log')

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

file_path = ARGV[0]
raise ArgumentError, "引数のファイルパスが入力されていません。" if file_path.nil?
raise IOError, "引数に指定されたファイル#{file_path}が存在しません。" unless File.exists?(file_path)

#octokit初期化
config = YAML.load_file("config.yml")
cl = Octokit::Client.new(access_token: config['access_token'])

gist_list = []
File.open(file_path, 'r') do |file|
  gist = Gist.new(file.path, file.read, config["description"], config["public"])
  gist_list << gist.create_content
end

gist_list.each do |gist|
  cl.create_gist(gist)
  logger.info gist
end
