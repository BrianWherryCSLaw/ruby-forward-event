# frozen_string_literal: true

require_relative "./forward_event/version"

module ForwardEvent
  INITIALS_REGEX = '(\"(?<initials>.*)\")?'
  MESSAGE_REGEX = '(?<message>[^\"]*)?'
  TEMPLATE_REGEX = '(\((?<template_name>.*)\))?'
  TIME_REGEX = '(\"(?<time>\d{2}:\d{2})\")?'
  OVCODE_REGEX = '_ov_code>OV\d+)?'

  TIME_OR_OV = "(?<time#{OVCODE_REGEX}#{TIME_REGEX}"
  MESSAGE_OR_OV = "((?<message#{OVCODE_REGEX}|#{MESSAGE_REGEX})?"
  INITIALS_OR_OV = "(?<initials#{OVCODE_REGEX}#{INITIALS_REGEX}"

  REGEX_START = "\\A\\[FE(?<days_to_add>\\d+)?(?<days#{OVCODE_REGEX}\\s+"
  REGEX_END = '\s*\]\z'
  REGULAR_EXPRESSIONS = [
    /#{REGEX_START}#{TIME_OR_OV}\s*#{TEMPLATE_REGEX}\s*#{MESSAGE_OR_OV}\s*#{INITIALS_OR_OV}#{REGEX_END}/,
    /#{REGEX_START}#{MESSAGE_REGEX}#{REGEX_END}/
  ]
end
