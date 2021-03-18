# frozen_string_literal: true

module ForwardEvent
  class Initials
    attr_reader :value

    REGEX = /\A\"(?<value>.*)\"\z/

    def initialize(raw_string)
      @value = REGEX.match(raw_string)[:value]
    end
  end
end
