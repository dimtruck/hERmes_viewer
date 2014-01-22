  require 'fileutils'
  require 'yaml'
  require 'logging'
  require 'redis'
  require 'open-uri'
  require File.expand_path("apps/bootstrap.rb", Dir.pwd)
  
  module Apps
    class PostgresSingularAppBootstrap < Bootstrap
   
  
      def initialize(environment = :production, redis_info = nil, logger = nil)
        if environment == :production
          @config = YAML.load_file(File.expand_path("config/apps/postgres_singular_app.yaml", Dir.pwd))
        elsif environment == :test
          @config = YAML.load_file(File.expand_path("config/apps/test_postgres_singular_app.yaml", Dir.pwd))
        elsif environment == :development
          @config = YAML.load_file(File.expand_path("config/apps/dev_postgres_singular_app.yaml", Dir.pwd))
        end
  
        super(redis_info, logger)      
      end
    end
  end