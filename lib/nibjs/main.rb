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
    
    # Install options
    options do |opt|
      opt.on_tail("--help", "Show help") do
        raise Quickl::Help
      end
      opt.on_tail("--version", "Show version") do
        raise Quickl::Exit, "#{program_name} #{NibJS::VERSION} (c) 2011, Bernard Lambeau"
      end
    end
      
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

    def compile(folder)
      puts with_nib_define(File.basename(folder)){
        Dir["#{folder}/**/*.coffee"].collect{|file|
          rel = file[(1+folder.size)..-8]
          with_registration("./#{rel}"){ File.read(file) }
        }.join("\n")
      }
    end
    
    def with_output
      yield($stdout)
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