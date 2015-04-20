require 'yaml'
require 'octokit'

class Gist
  attr_reader :client, :config
  
  def initialize
    @config = YAML.load_file("config.yml")
    @client = Octokit::Client.new(access_token: @config['access_token'])
  end

  #Gistを作成する
  def create_gist(file_name, file_content)
    gist_content = create_content(file_name, file_content)
    @client.create_gist(gist_content)
  end
  
  def get_gists
    gists = cl.gists(config['account_name'])
    gists.each do |gist|
      puts gist.id
    end
  end

  private
  # Gistを作成するすためのhashを作成する
  def create_content(name, content)
    gist_content = {}
    gist_content["description"] = @config["description"]
    gist_content["public"] = @config["public"]
    file_content = {}
    file_content["content"] = content
    file = {}
    file[name] = file_content
    gist_content["files"] = file
    return gist_content
  end
end