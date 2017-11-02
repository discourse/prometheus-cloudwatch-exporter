require 'toml'

module Prom
  class Config
    def self.load(file)
      new TOML.load_file(file)
    end

    def initialize(config)
      @config = config
    end

    def scrape_interval
      @config["scrape_interval"] || 30
    end

    def metrics
      return @metrics if @metrics

      @metrics = @config["counters"].map do |name, info|
        Metric.new(info["namespace"], info["name"], info["dimension_filter"], :counter)
      end
    end
  end
end
