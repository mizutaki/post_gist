require 'octokit'
require 'yaml'

config = YAML.load_file("config.yml")
puts config
cl = Octokit::Client.new(access_token: config['access_token'])
options = {
  "description"=> "the description for this gist",
  "public"=> true,
  "files"=> {
    "file3.txt"=> {
      "content"=> "String file contents"
    }
  }
}
cl.create_gist(options)