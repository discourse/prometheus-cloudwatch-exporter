module Prom
  class Extractor
    attr_reader :metrics

    def initialize(metrics)
      @metrics = metrics
    end

    def extract
      @metrics.map do |metric|
        extract_metric(metric)
      end
    end

    def extract_metric(metric)
      aws_metric = Aws::CloudWatch::Metric.new(metric.namespace, metric.name)
      aws_metric.get_statistics(
        dimensions: [

        ],
        start_time: Time.now,
        end_time: Time.now,
        period: 10,
        statistics: ["Sum"]
      )
    end
  end
end
