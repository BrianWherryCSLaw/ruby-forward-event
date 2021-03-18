# frozen_string_literal: true

require_relative "./parser_error"

module ForwardEvent
  class Parser
    DATE_REGEX = '(?<date>(\d{2}\/){2}\d{4})'
    INITIALS_REGEX = '(\"(?<initials>.*)\")'
    MESSAGE_REGEX = '(?<message>[^\"]*)'
    TEMPLATE_REGEX = '(\((?<template_name>.*)\))'
    TIME_REGEX = '(\"(?<time>\d{2}:\d{2})\")'
    OVCODE_REGEX = '_ov_code>OV\d+)'

    TIME_OR_OV = "((?<time#{OVCODE_REGEX}|#{TIME_REGEX}){1}"
    MESSAGE_OR_OV = "((?<message#{OVCODE_REGEX}|#{MESSAGE_REGEX}){1}"
    INITIALS_OR_OV = "((?<initials#{OVCODE_REGEX}|#{INITIALS_REGEX}){1}"

    REGEX_START = "\\A(\\[FE(#{DATE_REGEX}|(?<days_to_add>-?\\d+)|(?<days#{OVCODE_REGEX}){1}\\s+){1}"
    REGEX_END = '\s*\]\z'
    REGULAR_EXPRESSIONS = [
      /#{REGEX_START}#{TIME_OR_OV}\s*#{TEMPLATE_REGEX}\s*#{MESSAGE_OR_OV}\s*#{INITIALS_OR_OV}#{REGEX_END}/,
      /#{REGEX_START}#{MESSAGE_OR_OV}#{REGEX_END}/,
      /#{REGEX_START}#{TIME_OR_OV}\s+\"#{MESSAGE_OR_OV}\"\s+#{INITIALS_OR_OV}#{REGEX_END}/,
    ]

    def self.parse(raw_string)
      matching_regex = REGULAR_EXPRESSIONS.detect { |regex| regex =~ raw_string }
      raise ParserError.new("no matching regex found", raw_string) if matching_regex.nil?

      matches = matching_regex.match(raw_string)
      result = Hash[matches.names.map(&:to_sym).zip(matches.captures.map {|cap| cap.strip if cap.is_a? String })]

      # Might as well make :days_to_add a number
      unless result[:days_to_add].nil?
        result[:days_to_add] = result[:days_to_add].to_i
      end

      return result
    end
  end
end
