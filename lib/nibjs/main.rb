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
    
    attr_accessor :coffee
    attr_accessor :uglify
    
    # Install options
    options do |opt|
      @output = STDOUT
      opt.on("-o", "--output=FILE", "Output in a specific file") do |value|
        @output = value
      end
      @coffee = false
      opt.on("-c", "--coffee", "Specify if sources are in coffeescript") do
        @coffee = true
      end
      @uglify = false
      opt.on('-u', '--[no-]uglify', "Minimize generated javascript (requires uglifyjs)") do |value| 
        @uglify = value
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
    
    def files(folder)
      if coffee
        Dir["#{folder}/**/*.coffee"]
      else
        Dir["#{folder}/**/*.js"]
      end
    end

    def coffee_compile(code)
      with_temp_file(code){|f|
        safe_run("cat #{f.path} | coffee --compile --stdio --bare #{f.path}")
      }
    end

    def compile(folder)
      code = if coffee
        code = with_coffee_define(File.basename(folder)){
          files(folder).collect{|file|
            rel = file[(1+folder.size)..-8]
            with_coffee_registration("./#{rel}"){ File.read(file) }
          }.join("\n")
        }
        coffee_compile(code)
      else
        with_js_define(File.basename(folder)){
          files(folder).collect{|file|
            rel = file[(1+folder.size)..-8]
            with_js_registration("./#{rel}"){ File.read(file) }
          }.join("\n")
        }
      end
      if uglify
        with_temp_file(code){|f| safe_run("uglifyjs #{f.path}") }
      else
        code
      end
    end
    
    def with_output
      if String === @output 
        File.open(@output, 'w'){|io|
          yield(io)
        }
      else
        yield(@output)
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