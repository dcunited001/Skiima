# encoding: utf-8
module Skiima
  class Loader
    include Skiima::Config

    attr_accessor :env, :vars, :reader
    attr_accessor :dependencies, :db, :connection
    attr_accessor :direction
    attr_accessor :scripts
    attr_accessor :logger

    def defaults
      Skiima.config
    end

    def initialize(env, opts = {})
      @env = env
      merge_db_config(opts.delete('db') || {})
      get_config(opts)
      set_vars
      create_logger
      make_connection
      get_dependency_config
      create_dependency_reader
    end

    def up(*args)
      @direction = :up
      opts = args.last.is_a?(Hash) ? args.pop : {}
      read_and_execute(*args)
    end

    def down(*args)
      @direction = :down
      opts = args.last.is_a?(Hash) ? args.pop : {}
      read_and_execute(*args)
    end

    def make_connection
      resolver = Skiima::DbAdapters::Resolver.new(@db)
      @connection = Skiima.send(resolver.adapter_method, logger, db)
    end

    def log_message(msg)
      Skiima.log_message(logger, msg)
    end

    def read_and_execute(*scripts)
      read_scripts *scripts
      interpolate_each_script
      execute_each_script
    end

    private

    def set_vars
      @vars = config[:vars] || {}
    end

    def read_scripts(*args)
      @scripts = reader.get_load_order(*args)
      @scripts.reverse! if direction == :down
    end

    def interpolate_each_script
      scripts.each do |s|
        s.read_content(direction, full_scripts_path)
        s.content ||= connection.drop(s.type, s.name, {:attr => s.attr}.merge(config.to_hash)) if direction == :down
        s.interpolate_sql(interpolator, interpolation_vars)
      end
    end

    def execute_each_script
      scripts.each {|s| connection.execute(s.sql)}
    end

    def create_dependency_reader
      @reader = Skiima::Dependency::Reader.new(dependencies, db['adapter'], config)
    end

    def interpolation_vars
      { :database => db['database'] }.merge(config[:vars] || {})
    end

    def method_missing(method, *args, &block)
      config.respond_to?(method) ? config.send(method, *args) : super
    end

    def get_config(opts)
      @config = config.merge(opts)
    end

    def merge_db_config(db_config)
      @db = read_db_yml(full_database_path)[env].merge(db_config)
    end

    def get_dependency_config
      @dependencies = read_dependencies_yml(full_dependencies_path)
    end

    def create_logger
      @logger = Skiima::Logger.new config.slice(:logging_out, :logging_level)
    end
  end
end
