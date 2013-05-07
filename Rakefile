require 'bundler/setup'
require 'padrino-core/cli/rake'

PadrinoTasks.use(:database)
PadrinoTasks.use(:activerecord)
PadrinoTasks.init

namespace :metric do
  desc "project statistics"
  task 'stat' do
    puts "\nRuby:"
    stat_files Dir.glob('**/*.rb') - Dir.glob('test/**/*.rb') - Dir.glob('db/**/*.rb') - Dir.glob('config/**/*.rb')
  end
end

private
def stat_files fs
  c = 0
  fc = 0
  fs.each do |f|
    fc += 1
    data = File.binread f
    c += data.count "\n"
  end
  puts "files: #{fc}"
  puts "lines: #{c}"
end


