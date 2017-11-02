require_relative '../../test_helper.rb'

module Prom
  class TestCounter < MiniTest::Test
    def test_correctly_joins_buckets
      c = Counter.new(3)

      c.notify(0,1)
      c.notify(0,2)
      c.notify(1,2)
      c.notify(0,3)
      c.notify(2,1)

      assert_equal 6, c.value
    end

    def test_can_roll_up_total
      c = Counter.new(3)

      c.notify(0,1)
      c.notify(1,1)
      c.notify(2,1)
      c.notify(3,1)
      c.notify(3,2)
      c.notify(0,10) # ignored cause it was rolled over
      c.notify(3,3)

      assert_equal 6, c.value

    end
  end
end
