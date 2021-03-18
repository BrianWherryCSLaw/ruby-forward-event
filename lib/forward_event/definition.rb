# frozen_string_literal: true

require_relative "./definition_parse_error"
require_relative "./ov_code"
require_relative "./raw_argument_element"
require_relative "./time"
require_relative "./template_name"

module ForwardEvent
  class Definition
    attr_reader :days_to_add
    attr_reader :dps_command
    attr_reader :initials
    attr_reader :message
    attr_reader :template_name
    attr_reader :time

    def initialize(dps_command:)
      @dps_command = dps_command
      assign_args
    end

    private

    def args_array
      args_string.split(" ")
    end

    def args_string
      arg_string_regex = /\A\[FE(?<args_string>.*)\]\z/
      raise DefinitionParseError, "definition is not a valid FE command string" unless arg_string_regex.match @dps_command
         
      result = arg_string_regex.match(@dps_command)[:args_string]
      raise DefinitionParseError, "no arguments found in command" if result.nil?

      result = result.strip
      raise DefinitionParseError, "only whitespace in arguments" if result == ""

      return result
    end

    def assign_args
      to_assign = parsed_args
      days_arg = to_assign.shift
      @days_to_add = if days_arg.is_a? OVCode
                       days_arg
                     elsif days_arg !~ /-?\d+\z/
                       raise DefinitionParseError, "the first argument must be an integer between -9999 and 9999, if it is not an OVCode"
                     else
                       days_arg.to_i
                     end

      strings, non_strings = args.partition { |arg| arg.is_a? String }
      unless strings.empty?
        @message = strings.join(" ")
      end

      ov_codes, known_types = non_strings.partition { |arg| arg.is_a? ForwardEvent::OVCode }
      known_types.each do |arg|
        case arg
        when ForwardEvent::Time then @time = arg.value
        when ForwardEvent::TemplateName then @template_name = arg.value
        when ForwardEvent::Initials then @initials = arg.value
        end
      end

      ov_codes.each do |ov|
        
      end
    end

    def parsed_args
      result = args_array.map { |el| RawArgumentElement.new(el).parsed_type } 
      raise DefinitionParseError, "definition must have at least two args" if result.size < 2

      return result
    end
  end
end
