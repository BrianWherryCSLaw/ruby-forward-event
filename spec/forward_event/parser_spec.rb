# frozen_string_literal: true

require "forward_event/parser"

module ForwardEvent
  RSpec.describe Parser do
    describe "class methods" do
      describe ":parse" do
        test_data = [
          {
            input: "[FE1 banana womble]",
            expectation: {
              days_ov_code: nil,
              days_to_add: 1,
              initials: nil,
              initials_ov_code: nil,
              message_ov_code: nil,
              message: "banana womble",
              template_name: nil,
              time: nil,
              time_ov_code: nil
            }
          },
          {
            input: "[FE-1 banana womble]",
            expectation: {
              days_ov_code: nil,
              days_to_add: -1,
              initials: nil,
              initials_ov_code: nil,
              message_ov_code: nil,
              message: "banana womble",
              template_name: nil,
              time: nil,
              time_ov_code: nil
            }
          },
          {
            input: '[FE1 "12:34" (flume) banana womble "ABC"]',
            expectation: {
              days_ov_code: nil,
              days_to_add: 1,
              initials: "ABC",
              initials_ov_code: nil,
              message_ov_code: nil,
              message: "banana womble",
              template_name: "flume",
              time: "12:34",
              time_ov_code: nil
            }
          },
          {
            input: '[FE1 "12:34" "banana womble" OV2]',
            expectation: {
              days_ov_code: nil,
              days_to_add: 1,
              initials: nil,
              initials_ov_code: "OV2",
              message_ov_code: nil,
              message: "banana womble",
              template_name: nil,
              time: "12:34",
              time_ov_code: nil
            }
          },
          {
            input: '[FE11/12/1973 "12:34" "banana womble" OV2]',
            expectation: {
              date: "11/12/1973",
              days_ov_code: nil,
              days_to_add: nil,
              initials: nil,
              initials_ov_code: "OV2",
              message_ov_code: nil,
              message: "banana womble",
              template_name: nil,
              time: "12:34",
              time_ov_code: nil
            }
          },
          {
            input: '[FEOV1 "12:34" "banana womble" OV2]',
            expectation: {
              days_ov_code: "OV1",
              days_to_add: nil,
              initials: nil,
              initials_ov_code: "OV2",
              message_ov_code: nil,
              message: "banana womble",
              template_name: nil,
              time: "12:34",
              time_ov_code: nil
            }
          },
          {
            input: '[FEOV1 OV2 (flume) OV3 OV4]',
            expectation: {
              days_ov_code: "OV1",
              days_to_add: nil,
              initials: nil,
              initials_ov_code: "OV4",
              message_ov_code: "OV3",
              message: nil,
              template_name: "flume",
              time: nil,
              time_ov_code: "OV2"
            }
          },
          {
            input: "[FE1 OV2]",
            expectation: {
              days_ov_code: nil,
              days_to_add: 1,
              initials: nil,
              initials_ov_code: nil,
              message_ov_code: "OV2",
              message: nil,
              template_name: nil,
              time: nil,
              time_ov_code: nil
            }
          },
          {
            input: "[FEOV1 OV2]",
            expectation: {
              days_ov_code: "OV1",
              days_to_add: nil,
              initials: nil,
              initials_ov_code: nil,
              message_ov_code: "OV2",
              message: nil,
              template_name: nil,
              time: nil,
              time_ov_code: nil
            }
          },
          {
            input: "[FEOV1 banana womble]",
            expectation: {
              days_ov_code: "OV1",
              days_to_add: nil,
              initials: nil,
              initials_ov_code: nil,
              message_ov_code: nil,
              message: "banana womble",
              template_name: nil,
              time: nil,
              time_ov_code: nil
            }
          }
        ]

        test_data.each do |datum|
          context "when argument is '#{datum[:input]}'" do
            result = Parser.parse datum[:input]
            expectation = datum[:expectation]

            it "is expected to return #{expectation.inspect}" do
              expectation.keys.each do |key|
                expect(result[key]).to eq expectation[key]
              end
            end
          end
        end
      end
    end
  end
end
