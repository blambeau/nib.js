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
  #   Package an application from sources in FOLDER
  #
  class Main < Quickl::Command(__FILE__, __LINE__)
    
    # Name of the library which is packaged
    attr_accessor :libname
    
    # Compile the sources using coffee first
    attr_accessor :coffee
    
    # Join the sources instead of treating them separately
    attr_accessor :join
    
    # Invoke ugligyjs on result
    attr_accessor :uglify
    
    # Add 'libname = NibJS.require(libname)' at end of script
    attr_accessor :autorequire
    
    # Path to a licencing file to add as header
    attr_accessor :header
    
    # IO or filename where to output result
    attr_accessor :output
    
    # Install options
    options do |opt|
      @libname = File.basename(File.expand_path("."))
      opt.on("--libname=X", "Specify the main library name") do |value|
        @libname = value
      end
      @autorequire = false
      opt.on('-a','--autorequire', "Add 'libname = NibJS.require(libname)' at end of script") do
        @autorequire = true
      end
      @coffee = false
      opt.on("-c", "--coffee", "Compile the sources using coffee first (requires coffee)") do
        @coffee = true
      end
      @join = false
      opt.on('-j', '--join', "Join the sources instead of treating them separately") do |value|
        @join = true
      end
      @uglify = false
      opt.on('-u', '--[no-]uglify', "Invoke ugligyjs on result (requires uglifyjs)") do |value| 
        @uglify = value
      end
      opt.separator('')
      @output = STDOUT
      opt.on("--header=FILE", "Add a (licencing) header from a file") do |value|
        @header = value
      end
      @output = STDOUT
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
      code += yield.gsub(/^/m, '  ')
      code += "\n\n"
    end

    def with_coffee_define(package)
      code = ""
      code += "NibJS.define '#{package}', (nibjs)->\n"
      code += yield.gsub(/^/m, '  ')
      code += "\n"
      code += "  nibjs.require './index'\n"
    end
    
    ### In javascript
    
    def with_js_registration(file)
      code = ""
      code += "nibjs.register('#{file}', function(exports, require){\n"
      code += yield.gsub(/^/m, '  ')
      code += "});\n\n"
    end

    def with_js_define(package)
      code = ""
      code += "NibJS.define('#{package}', function(nibjs){\n"
      code += yield.gsub(/^/m, '  ')
      code += "\n"
      code += "  nibjs.require('./index');\n"
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
    
    def collect_on_files(folder)
      files = if coffee
        Dir["#{folder}/**/*.coffee"]
      else
        Dir["#{folder}/**/*.js"]
      end
      if join
        files.sort!
        content = files.collect{|f| File.read(f)}.join("\n")
        [ with_temp_file(content){|f| yield(f.path, 'index')} ]
      else
        files.collect{|f| yield(f, f[(1+folder.size)..-8])}
      end
    end

    def coffee_compile(code)
      with_temp_file(code){|f|
        safe_run("cat #{f.path} | coffee --compile --stdio --bare #{f.path}")
      }
    end

    def compile(folder)
      # compile it
      code = if coffee
        code = with_coffee_define(libname){
          collect_on_files(folder){|filepath, filename|
            with_coffee_registration("./#{filename}"){ File.read(filepath) }
          }.join("\n")
        }
        coffee_compile(code)
      else
        with_js_define(File.basename(folder)){
          collect_on_files(folder).collect{|filepath, filename|
            with_js_registration("./#{filename}"){ File.read(filepath) }
          }.join("\n")
        }
      end

      # Add the autorequire line if requested
      if autorequire
        code += "var #{libname} = NibJS.require('#{libname}');\n"
      end
      
      if header
        code = File.read(header) + "\n" + code
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
        with_output{|io| io << compile(args[0])}
      else
        raise Quickl::Help
      end
    end

  end # class Main
end # module NibJS