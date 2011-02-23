desc "Builds the github pages"
task :pages do
  shell_safe_exec("cp -R #{_('examples/*')} #{_('gh-pages')}")
  shell_safe_exec("rm -rf #{_('gh-pages/illustrations.graffle')}")
  shell_safe_exec("cd #{_('gh-pages')} && git commit -a -m 'Regenerated doc.' && git push origin")
end