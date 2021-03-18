# frozen_string_literal: true

require_relative "./initials"
require_relative "./ov_code"
require_relative "./template_name"
require_relative "./time"

module ForwardEvent
  class RawArgumentElement
    attr_reader :raw_string

    def initialize(raw_string)
      @raw_string = raw_string
      set_type
    end

    def parsed_type
      case @raw_string
      when OVCode::REGEX 
        OVCode.new @raw_string
      when TemplateName::REGEX
        TemplateName.new @raw_string
      when ::ForwardEvent::Time::REGEX
        ::ForwardEvent::Time.new @raw_string
      when Initials::REGEX
        Initials.new @raw_string
      else
        @raw_string.strip
      end
    end

    def to_i
      @raw_string.to_i
    end

    private

    def set_type
      case @raw_string
      when OVCode::REGEX 
        @type = 'ov_code'
      when TemplateName::REGEX
        @type = 'template_name'
      when ::ForwardEvent::Time::REGEX
        @type = 'time'
      when Initials::REGEX
        @type = 'initials'
      else
        @type = 'string'
      end
    end
  end
end
