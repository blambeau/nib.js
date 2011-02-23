def _(file)
  File.expand_path("../#{file}", __FILE__)
end
def nibjs(*options)
  here = File.dirname(__FILE__)
  nibjs = File.join(here, '..', 'bin', 'nibjs')
  Kernel.system "#{nibjs} #{options.flatten.join('  ')}"
end
def __output(file)
  "--output=\"#{file}\""
end