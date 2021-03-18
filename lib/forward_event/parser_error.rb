# frozen_string_literal: true

module ForwardEvent
  class ParserError < ::StandardError
    attr_reader :raw_string

    def initialize(msg="could not parse string", raw_string="unknown")
      @raw_string = raw_string
      super(msg)
    end
  end
end
