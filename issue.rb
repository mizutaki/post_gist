require 'yaml'
require 'octokit'
require 'csv'

class Issue
  attr_reader :client
  
  def initialize
    @config = YAML.load_file("config.yml")
    @client = Octokit::Client.new(access_token: @config['access_token'])
  end
  
  def create_issues_csv(csv_file)
  	csv = CSV.read(csv_file, headers: true)
    csv.each do |row|
      raise ArgumentError.new('CSVファイルのカラム数が多すぎます') if row.length > 3
      create_issue(row.fields[0], row.fields[1],row.fields[2])
    end
  end

  def create_issue(repository, title, body)
    @client.create_issue(repository, title, body)
  end
end