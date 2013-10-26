require_relative 'models.rb'
require_relative 'runner.rb'
require_relative 'plugin.rb'

require 'yaml'

module Models
  class Bootstrap
    attr_reader :config, :logger
    @@applications ||= []

    def self.logger
      Logging.color_scheme( 'bright',
        :levels => {
          :info  => :green,
          :warn  => :yellow,
          :error => :red,
          :fatal => [:white, :on_red]
        },
        :date => :blue,
        :logger => :cyan,
        :message => :magenta
      )
      logger = Logging.logger(STDOUT)
      logger.level = :debug
    end

    def self.inherited(klass)
      @@applications << klass
    end

    def runner_list
      {
 	:jmeter => Models::JMeterRunner.new,
 	:pravega => Models::PravegaRunner.new,
  	:flood => Models::FloodRunner.new,
  	:autobench => Models::AutoBenchRunner.new
      }
    end

    def load_plugins
      plugin_list = @config['application']['plugins']
      plugin_list.each do |key, entry| 
        require entry unless File.directory?(entry)
      end
      Plugin.plugin_list 
    end

    def start_test_recording
      raise NotImplementedError, 'Your bootstrap must implement start_test_recording method'
    end

    def stop_test_recording
      raise NotImplementedError, 'Your bootstrap must implement stop_test_recording method'
    end
  end
end
