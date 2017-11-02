require 'aws-sdk-cloudwatch'

module Prom
  class Metric
    attr_reader :namespace, :name, :dimension_filter

    def initialize(namespace, name, dimension_filter, type)
      @namespace = namespace
      @name = name
      @dimensions = []
      @counters = {}

      @dimension_filter = nil
      if dimension_filter
        @dimension_filter = dimension_filter.map do |k, v|
          if v[0] == "/" && v[-1] == "/"
            v = Regexp.new(v[1..-2])
          end
          {
            name: k,
            value: v
          }
        end
      end

      @start = Time.now
    end

    def refresh_dimensions
      @dimensions = Aws::CloudWatch::Client.new.list_metrics(
        namespace: namespace,
        metric_name: name
      ).metrics.map do |metric|
          metric.dimensions.map do |d|
            {
              name: d.name,
              value: d.value
            }
          end
        end
    end

    def report_stat(dimension, stat)
      counter = @counters[dimension] ||= Counter.new
      bucket = ((stat.timestamp-@start) / 60).to_i

      return if bucket < 0
      p Time.now
      p stat.timestamp
      p bucket
      p stat.sum
      counter.notify(bucket, stat.sum)
    end

    def refresh
      aws_metric = Aws::CloudWatch::Metric.new(namespace, name)

      @dimensions.each do |d|
        p d
        aws_metric.get_statistics(
          dimensions: d,
          start_time: Time.now - 300,
          end_time: Time.now,
          period: 60,
          statistics: ["Sum"]
        )[1].each { |stat|
          report_stat(d,stat)
        }
      end
    end

  end
end
