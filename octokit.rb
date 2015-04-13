require 'octokit'
require 'yaml'
require 'pry'
require 'pp'

class Gist
  attr_reader :file_name, :file_content, :description, :public
  def initialize(file_name, file_content, description, public)
    @file_name = file_name
    @file_content = file_content
    @description = description
    @public  = public
  end

  def create_gist_content
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

config = YAML.load_file("config.yml")
cl = Octokit::Client.new(access_token: config['access_token'])
exec_path = File.expand_path(File.dirname(__FILE__))
files = []
Dir.entries(".").each do |file|
  files << file if file != __FILE__ && File.extname(file) == '.rb'
end

gist_files = []
files.each do |file|
  File.open(file, 'r') do |file|
    puts file.class
    gist = Gist.new(file.path, file.read, "", true)
    gist_files << gist
  end
end

gist_files.each do |gist|
  g = gist.create_gist_content
  pp g
  cl.create_gist(g)
end
