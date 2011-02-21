desc "Compile src/nib.coffee -> src/nib.js"
task :build do
  shell_safe_exec("coffee --compile --bare src")
end