require 'fileutils'
require 'logger'
require_relative 'gist'

#Loggerの設定
FileUtils.mkdir('log') unless File.exists?('./log')
logger = Logger.new('./log/octokit.log')

file_path = ARGV[0]
raise ArgumentError, "引数のファイルパスが入力されていません。" if file_path.nil?
raise IOError, "引数に指定されたファイル#{file_path}が存在しません。" unless File.exists?(file_path)

gist = Gist.new
File.open(file_path, 'r') do |file|
  gist.create_gist(file.path, file.read)
end