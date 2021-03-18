# frozen_string_literal: true

module ForwardEvent
  class OVCode
    attr_reader :raw_string
    attr_reader :value

    REGEX = /\AOV(?<value>\d+)\z/

    def initialize(raw_code)
      @raw_code = raw_code
      @value = @raw_code.strip[2..].to_i
    end
  end
end
