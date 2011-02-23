require 'nibjs'
module NibJS
  #
  # nibjs - Package and embed node.js/coffeescript application in your browser
  #
  # SYNOPSIS
  #   #{program_name} [--help] [--version] [FOLDER]
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #   This command packages a complete javascript/coffeescript as a single .js file 
  #   to be embedded in the browser. Basically, it defines Node.js's exports and 
  #   require to work nicely. For this, we expect a project structure that respect
  #   Node.js's package conventions (exports, require, index): 
  #
  #     mylib/
  #       dist/
  #       src/
  #         foo.[js,coffee]            # exports.Foo = ...
  #         bar.[js,coffee]            # require('./foo')
  #         index.[js,coffee]          # exports.X = ...
  #       spec/
  #         foo_spec.[js,coffee]
  #         bar_spec.[js,coffee]
  #
  # EXAMPLE 1 (embedded javascript):
  #
  #   In a shell:
  #
  #       # if the sources are .js
  #       nibjs --libname=mylib --output=mylib.js src
  #
  #       # if the sources are .coffee
  #       nibjs --coffee --libname=mylib --output=mylib.js src
  #
  #   In the browser:
  #
  #     <script src="js/coffee-script.js" type="text/javascript">
  #     <script src="js/nibjs.js" type="text/javascript">
  #     <script src="js/mylib.js" type="text/javascript">
  #     <script>
  #       var mylib = NibJS.require('mylib')
  #     </script>
  #
  # EXAMPLE 2 (embedded coffeescript):
  #
  #   In a shell:
  #
  #     nibjs --coffee --no-coffee-compile --libname=mylib --output=mylib.coffee src
  #
  #   In the browser:
  #
  #     <script src="js/nibjs.js"     type="text/javascript">
  #     <script src="js/mylib.coffee" type="text/coffeescript">
  #     <script>
  #       /* But be warned of coffeescript's issue 1054
  #          https://github.com/jashkenas/coffee-script/issues/#issue/1054 */
  #       var mylib = NibJS.require('mylib')
  #     </script>
  #
  class Main < Quickl::Command(__FILE__, __LINE__)
    
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
      @libname = nil
      opt.on("--libname=X", "Specify the main library name") do |value|
        @libname = value
      end
      @autorequire = false
      opt.on('-a', '--[no-]autorequire', "Add 'libname = NibJS.require(libname)' at end of script") do |value|
        @autorequire = value
      end
      @coffee = false
      opt.on("-c", "--coffee", "Look for .coffee instead of .js files (requires coffee)") do
        @coffee = true
      end
      @coffee_compile = true
      opt.on("--[no-]coffee-compile", "Compile .coffee sources to javascript (requires coffee)") do |value|
        @coffee_compile = value
      end
      @join = false
      opt.on('-j', '--[no-]join', "Join the sources instead of treating them separately") do |value|
        @join = value
      end
      @uglify = false
      opt.on('-u', '--[no-]uglify', "Invoke ugligyjs on result (requires uglifyjs)") do |value| 
        @uglify = value
      end
      opt.separator('')
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

    def compile(folder)
      folder = File.expand_path(folder)
      self.libname ||= File.basename(folder)
      if self.libname =~ /(.*)\.\w/
        self.libname = $1
      end
      
      code = if coffee
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

      # Add the autorequire line if requested
      if autorequire 
        if coffee_output?
          code += "#{libname} = NibJS.require '#{libname}'\n"
        else
          code += "var #{libname} = NibJS.require('#{libname}');\n"
        end
      end
      
      if header
        code = File.read(header) + "\n" + code
      end
      if footer 
        code += "\n" + File.read(footer)
      end
      
      # Uglify result now
      if uglify
        code = with_temp_file(code){|f| safe_run("uglifyjs #{f.path}") } 
      end
      
      code
    end
    
    def with_output
      if String === output 
        File.open(output, 'w'){|io| yield(io) }
      else
        yield(output)
      end
    end

    def execute(args)
      if args.size == 1
        with_output{|io| io << compile(args[0]) }
      else
        raise Quickl::Help
      end
    end

  end # class Main
end # module NibJS