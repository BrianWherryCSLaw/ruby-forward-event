# frozen_string_literal: true

module ForwardEvent
  class Time
    REGEX = /\A\"(?<value>\d{2}:\d{2})\"\z/

    attr_reader :value

    def initialize(value)
      @value = REGEX.match(value)[:value]
    end
  end
end
