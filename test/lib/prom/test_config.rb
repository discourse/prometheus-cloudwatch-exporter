require_relative '../../test_helper.rb'

module Prom
  class TestConfig < MiniTest::Test
    def test_can_define_counters
      toml = <<~TOML


      [counters]

      [counters.http_target_2xx_count]
      namespace = "AWS/ApplicationELB"
      name = "HTTPCode_Target_2XX_Count"

      [counters.http_target_2xx_count.dimension_filter]
      TargetGroup = "/cdck-prod-meta-meta/"

      [counters.http_target_3xx_count]
      namespace = "AWS/ApplicationELB"
      name = "HTTPCode_Target_3XX_Count"

      [counters.http_target_3xx_count.dimension_filter]
      TargetGroup = "/cdck-prod-meta-meta/"
      TOML

      config = Config.new(TOML.load(toml))

      assert_equal 2, config.metrics.length
      metric = config.metrics.first

      assert_equal "AWS/ApplicationELB", metric.namespace
      assert_equal "HTTPCode_Target_2XX_Count", metric.name
      assert_equal [{name: "TargetGroup", value: /cdck-prod-meta-meta/}], metric.dimension_filter
    end
  end
end
