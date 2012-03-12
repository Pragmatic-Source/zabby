# -*- encoding: utf-8 -*-
# Author:: Farzad FARID (<ffarid@pragmatic-source.com>)
# Copyright:: Copyright (c) 2011 Farzad FARID
# License:: Simplified BSD License

require 'singleton'
begin
  require 'readline'
rescue LoadError
  # No readline
end


module Zabby
  # This is the main interpreter.
  # Additional shell commands are defined in the ShellHelpers module.
  class Runner
    include Singleton
    include ShellHelpers

    attr_reader :config, :connection

    def initialize &block
      @config = Zabby::Config.new
      @connection = Zabby::Connection.new
      @pure_binding = instance_eval "binding"

      # Configure the application
      run(&block) if block_given?

      # Configure Readline for the shell, if available
      if Object.const_defined?(:Readline)
        @readline = true
        Readline.basic_word_break_characters = ""
			  Readline.completion_append_character = nil
			  #Readline.completion_proc = completion_proc

			  $last_res = nil
      else
        # Without Readline the Zabby shell is not available.
        @readline = false
      end
    end

    # Execute script file and/or instruction block
    # @param [String] command_file Filename containing commands to execute.
    # @param [Proc] block A block containing commands to execute.
    def run(command_file = nil, &block)
      unless command_file.nil?
        commands = File.read(command_file)
        instance_eval(commands, command_file, 1)
      end
      instance_eval(&block) if block_given?
    end

    # Execute an irb like shell in which we can type Zabby commands.
    def shell
      raise RuntimeError.new("Shell cannot run because 'readline' is missing.") if !@readline

      puts "Zabby Shell #{Zabby::VERSION}"
      puts
      puts "** This is a simple irb like Zabbix Shell. Multiline commands do not work for e.g. **"
      loop do
        cmd = Readline.readline('zabby> ')

        exit(0) if cmd.nil? or cmd == 'exit'
        next if cmd == ""
        Readline::HISTORY.push(cmd)

        execute(cmd)
      end
    end

    private

    # Run a single command.
    # @param [String] cmd A command to execute in the object's context.
    def execute(cmd)
      res = eval(cmd, @pure_binding)
      $last_res = res
      eval("_ = $last_res", @pure_binding)
      print_result res
    rescue ::Exception => e
      puts "Exception #{e.class} -> #{e.message}"
      e.backtrace.each do |t|
        puts "   #{::File.expand_path(t)}"
      end
    end

    # Print a single command's output on the screen using "inspect" if necessary.
    # @param [Object] res Result object to display
    def print_result(res)
      if res.kind_of? String
        puts res
      elsif res.nil?
        # Do not print nil values
      else
        puts "=> #{res.inspect}"
      end
    end
  end
end
