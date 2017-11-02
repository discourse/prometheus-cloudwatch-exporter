# this is an intelligent conter that will "fill in" buckets of time as it goes
#
module Prom
  class Counter

    def initialize(buffer_buckets=10)
      @buffer_buckets = buffer_buckets
      @buffer_pos = 0
      @buffers = []
      @total = 0.0
    end

    def notify(bucket, value)
      if @buffer_pos > bucket
        # skip, this is old data
      elsif bucket < @buffer_buckets+@buffer_pos
        @buffers[bucket - @buffer_pos] = value
      else
        # future bucket so roll over
        while @buffer_pos <= (bucket - @buffer_buckets)
          @buffer_pos += 1
          @total += @buffers.shift.to_f
        end
      end
    end

    def value
      @total + @buffers.sum
    end
  end
end
