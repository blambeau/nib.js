desc "Builds the github pages"
task :pages do
  shell_safe_exec("cp -R #{_('examples/*')} #{_('gh-pages')}")
  shell_safe_exec("rm -rf #{_('gh-pages/illustrations.graffle')}")
  
  analytics = File.read(File.expand_path('../analytics.txt', __FILE__))
  analytics.gsub!(/^/m, '    ')
  Dir[_("gh-pages/**/index.html")].each{|file|
    puts "On #{file}"
    content = File.read(file)
    content.gsub!(/^\s*<\/body>/, analytics + "  </body>")
    File.open(file, 'w'){|io| io << content}
  }
  shell_safe_exec("cd #{_('gh-pages')} && git commit -a -m 'Regenerated doc.' && git push origin")
end