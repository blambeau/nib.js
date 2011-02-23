require 'nibjs'
module NibJS
  #
  # nibjs - Package and embed node.js/coffeescript application in your browser
  #
  # SYNOPSIS
  #   #{program_name} [--help] [--version] [FOLDER]
  #
  # #{summarized_options}
  #
  # DESCRIPTION
  #   This command packages a complete javascript/coffeescript as a single .js file 
  #   to be embedded in the browser. Basically, it defines Node.js's exports and 
  #   require to work nicely. For this, we expect a project structure that respect
  #   Node.js's package conventions (exports, require, index): 
  #
  #   See typical use cases at http://blambeau.github.com/nibjs
  #
  class Main < Quickl::Command(__FILE__, __LINE__)
    
    # Source folder that we compile
    attr_accessor :folder
    
    # Name of the library which is packaged
    attr_accessor :libname
    
    # Look for .coffee files
    attr_accessor :coffee
    
    # Compile .coffee files
    attr_accessor :coffee_compile
    
    # Join the sources instead of treating them separately
    attr_accessor :join
    
    # Invoke ugligyjs on result
    attr_accessor :uglify
    
    # Add 'libname = NibJS.require(libname)' at end of script
    attr_accessor :autorequire
    
    # Embed NibJS in output
    attr_accessor :standalone
    
    # Path to a licencing file to add as header
    attr_accessor :header
    
    # Path to a file to add as footer
    attr_accessor :footer
    
    # IO or filename where to output result
    attr_accessor :output
    
    def initialize
      @output = STDOUT
    end
    
    # Install options
    options do |opt|
      opt.separator("MAIN OPTIONS")
      @libname = nil
      opt.on("--libname=X", "Specify the main library name") do |value|
        @libname = value
      end
      @autorequire = false
      opt.on('-a', '--[no-]autorequire', "Add 'libname = NibJS.require(libname)' at end of script") do |value|
        @autorequire = value
      end
      @header = nil
      opt.on("--header=FILE", "Add a (licencing) header from a file") do |value|
        @header = value
      end
      @header = nil
      opt.on("--footer=FILE", "Add a footer from a file") do |value|
        @footer = value
      end
      #@output = STDOUT
      opt.on("-o", "--output=FILE", "Output in a specific file") do |value|
        @output = value
      end
      opt.separator("\nCOFFEESCRIPT\n")
      @coffee = false
      opt.on("-c", "--coffee", "Look for .coffee instead of .js files (requires coffee)") do
        @coffee = true
      end
      @coffee_compile = true
      opt.on("--[no-]coffee-compile", "Compile .coffee sources to javascript (requires coffee)") do |value|
        @coffee_compile = value
      end
      opt.separator("\nEXTRAS\n")
      @join = false
      opt.on('-j', '--[no-]join', "Join the sources instead of treating them separately") do |value|
        @join = value
      end
      @uglify = false
      opt.on('-u', '--[no-]uglify', "Invoke ugligyjs on result (requires uglifyjs)") do |value| 
        @uglify = value
      end
      @standalone = false
      opt.on('-s', '--[no-]standalone', "Embed NibJS itself in the output") do |value| 
        @standalone = value
      end
      opt.separator("\nABOUT\n")
      opt.on_tail("--help", "Show help") do
        raise Quickl::Help
      end
      opt.on_tail("--version", "Show version") do
        raise Quickl::Exit, "#{program_name} #{NibJS::VERSION} (c) 2011, Bernard Lambeau"
      end      
    end
    
    ### In coffee
      
    def with_coffee_registration(file)
      code = ""
      code += "nibjs.register '#{file}', (exports, require)->\n"
      code += yield.strip.gsub(/^/m, '  ') + "\n"
      code += "\n"
    end

    def with_coffee_define(package)
      code = ""
      code += "NibJS.define '#{package}', (nibjs)->\n"
      code += yield.strip.gsub(/^/m, '  ') + "\n"
      code += "\n"
      code += "  nibjs.require './index'\n"
    end
    
    ### In javascript
    
    def with_js_registration(file)
      code = ""
      code += "nibjs.register('#{file}', function(exports, require) {\n"
      code += yield.strip.gsub(/^/m, '  ') + "\n"
      code += "});\n"
    end

    def with_js_define(package)
      code = ""
      code += "NibJS.define('#{package}', function(nibjs) {\n"
      code += yield.strip.gsub(/^/m, '  ') + "\n"
      code += "  return nibjs.require('./index');\n"
      code += "});\n"
    end
    
    ###
    
    # Runs a command, returns result on STDOUT. If the exit status was no 0,
    # a RuntimeError is raised. 
    def safe_run(cmd)
      res = `#{cmd}`
      unless $?.exitstatus == 0
        raise RuntimeError, "Error while executing #{cmd}" 
      end
      res
    end
    
    def with_temp_file(content)
      require "tempfile"
      file = Tempfile.new('nibjs')
      file << content
      file.close
      res = yield(file)
      file.unlink
      res
    end
    
    ###
    
    def normalize_libname(folder, libname)
      libname ||= File.basename(folder)
      if libname =~ /(.*)\.\w/
        libname = $1
      end
      libname
    end
    
    def coffee_output?
      coffee && !coffee_compile
    end
    
    def file2require(root_folder, file)
      root_folder, file = File.expand_path(root_folder), File.expand_path(file)
      stripped = file[(1+root_folder.size)..-1]
      stripped =~ /(.*)\.(js|coffee)$/
      "./#{$1}"
    end
    
    ###
    
    def collect_on_files(folder)
      files = if coffee
        Dir["#{folder}/**/*.coffee"]
      else
        Dir["#{folder}/**/*.js"]
      end
      if join
        files.sort!
        content = files.collect{|f| File.read(f)}.join("\n")
        [ with_temp_file(content){|f| yield(f.path, './index')} ]
      else
        files.collect{|f| yield(f, file2require(folder, f))}
      end
    end

    def compile_coffee_source(code)
      with_temp_file(code){|f|
        safe_run("cat #{f.path} | coffee --compile --stdio --bare")
      }
    end
    
    def __main_compile
      if coffee
        code = with_coffee_define(libname){
          collect_on_files(folder){|filepath, reqname|
            with_coffee_registration(reqname){ File.read(filepath) }
          }.join
        }
        if coffee_compile
          compile_coffee_source(code) 
        else
          code
        end
      else
        with_js_define(libname){
          collect_on_files(folder){|filepath, reqname|
            with_js_registration(reqname){ File.read(filepath) }
          }.join
        }
      end
    end

    ###
    
    def with_autorequire
      code = yield
      if autorequire 
        if coffee_output?
          code += "#{libname} = NibJS.require '#{libname}'\n"
        else
          code += "var #{libname} = NibJS.require('#{libname}');\n"
        end
      else 
        code
      end
    end
    
    def with_standalone
      if standalone
        code = if coffee_output?
          coffeesrc = File.read(File.expand_path('../../../src/nibjs.coffee', __FILE__))
          "NibJSBuild = (exports)->\n" + coffeesrc.gsub(/^/m, '  ') + "\nNibJSBuild(this)\n"
        else
          File.read(File.expand_path("../../../dist/nibjs-#{NibJS::VERSION}.js", __FILE__))
        end
        code += "\n\n" + yield
      else
        yield
      end
    end

    def with_header_and_footer
      code = ""
      if header
        code += File.read(header) + "\n"
      end
      code += yield
      if footer 
        code += "\n" + File.read(footer)
      end
      code
    end
    
    def with_uglify
      if uglify
        with_temp_file(yield){|f| safe_run("uglifyjs #{f.path}") } 
      else 
        yield
      end
    end

    def with_output
      if String === output 
        File.open(output, 'w'){|io| io << yield }
      else
        output << yield
      end
    end

    def compile
      with_output{
        with_uglify{
          with_header_and_footer{
            with_standalone{
              with_autorequire{ __main_compile }
            }
          }
        }
      }
    end
    
    def execute(args)
      if args.size == 1
        @folder  = File.expand_path(args[0])
        @libname = normalize_libname(@folder, @libname)
        compile
      else
        raise Quickl::Help
      end
    end

  end # class Main
end # module NibJS