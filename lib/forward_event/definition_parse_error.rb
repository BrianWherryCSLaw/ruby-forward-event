# frozen_string_literal

module ForwardEvent
  class DefinitionParseError < ::StandardError
    def initialize(msg="definition could not be parsed")
      super
    end
  end
end
