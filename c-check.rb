#!/usr/bin/ruby
# encoding: UTF-8

require 'yaml'

p ARGV

score = ARGV[0].to_f
cclog = STDIN.read

report = {
  'badge'   => if score >= 0 then 'OK:' else 'OMG!' end + ' ' + (score.round(3) * 1000).to_i.to_s + '‰',
  'message' => cclog
}

File.open(ARGV[1], 'w:UTF-8' ) do |y|
  y.write report.to_yaml
end
