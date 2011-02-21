#!/usr/bin/env ruby

def with_registration(file)
  code = ""
  code += "nibjs.register '#{file}', (exports, require)->\n"
  code += yield.gsub(/^/m, '  ')
  code += "\n\n"
end

def with_nib_define(package)
  code = ""
  code += "NibJS.define '#{package}', (nibjs)->\n"
  code += yield.gsub(/^/m, '  ')
  code += "\n"
  code += "  nibjs.require './index'"
  code += "\n"
end

folder = File.expand_path(ARGV[0])

puts with_nib_define(File.basename(folder)){
  Dir["#{folder}/**/*.coffee"].collect{|file|
    rel = file[(1+folder.size)..-8]
    with_registration("./#{rel}"){ File.read(file) }
  }.join("\n")
}
