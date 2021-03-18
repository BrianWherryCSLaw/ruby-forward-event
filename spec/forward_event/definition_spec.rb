# frozen_string_literal: true

require "forward_event/definition"

module ForwardEvent
  RSpec.describe "Definition" do
    let!(:dps_command) { "[FE1 Banana Hatstand]" }
    let!(:definition) { Definition.new dps_command: dps_command }
    subject { definition }

    it { is_expected.to be_an_instance_of ForwardEvent::Definition }

    describe "class methods" do
      describe ":new" do
        test_data = [
          {
            input: "[FE1 Banana Womble]",
            expectation: {
              days_to_add: 1,
              message: "Banana Womble",
              dps_command: "[FE1 Banana Womble]",
              initials: nil,
              template_name: nil,
              time: nil
            }
          },
          {
            input: "[FEOV1 Banana Womble]",
            expectation: {
              days_to_add: ForwardEvent::OVCode.new("OV1"),
              message: "Banana Womble",
              dps_command: "[FEOV1 Banana Womble]",
              initials: nil,
              template_name: nil,
              time: nil
            }
          },
          {
            input: '[FE69 "12:34" Banana Womble]',
            expectation: {
              days_to_add: 69,
              message: "Banana Womble",
              dps_command: '[FE69 "12:34" Banana Womble]',
              initials: nil,
              template_name: nil,
              time: "12:34"
            }
          },
          {
            input: '[FE69 "12:34" (Flume) Banana Womble "BRW"]',
            expectation: {
              days_to_add: 69,
              message: "Banana Womble",
              dps_command: '[FE69 "12:34" (Flume) Banana Womble "BRW"]',
              initials: "BRW",
              template_name: "Flume",
              time: "12:34"
            }
          }
        ]

        test_data.each do |datum|
          context "when dps_commad is '#{datum[:input]}'" do
            let(:definition) { Definition.new dps_command: datum[:input] }

            datum[:expectation].each do |attr, value|

              it "sets #{attr} to #{value}" do
                actual = definition.instance_variable_get("@#{attr}")
                if value.is_a? ForwardEvent::OVCode
                  expect(actual.value).to eq value.value
                else
                  expect(definition.instance_variable_get("@#{attr}")).to eq value
                end
              end
            end
          end
        end
      end
    end

    describe "private methods" do
      describe ":args_array" do
        context "when multiple spaces in a quoted string" do
          before { subject.instance_variable_set :@dps_command, "[FEOV42 \"womble\t  flume\"]" }

          it "keeps whitespace characters intact" do
            expectation = ["OV42", ' "', "womble", "\t  ", "flume", '"']
            expect(subject.send(:args_array)).to eq expectation
          end
        end
      end

      describe ":args_string" do
        context "when dps_command is not in [FExxxx] format" do
          before { subject.instance_variable_set :@dps_command, "womble" }

          it "raises a DefinitionParseError" do
            expect{subject.send(:args_string)}.to raise_error(DefinitionParseError)
          end
        end

        context "when dps_command is in [FExxxx] format" do
          context "and has no arguments" do
            before { subject.instance_variable_set :@dps_command, "[FE]" }

            it "raises a DefinitionParseError" do
              expect{subject.send(:args_string)}.to raise_error(DefinitionParseError)
            end
          end

          context "and has only whitespace for arguments" do
            before { subject.instance_variable_set :@dps_command, "[FE   \n\t  ]" }

            it "raises a DefinitionParseError" do
              expect{subject.send(:args_string)}.to raise_error(DefinitionParseError)
            end
          end
        end
      end

      describe ":parse_raw_args" do
        context "when the definition string hash less than two argument elements" do
          before { allow(subject).to receive(:args_array) { [] } }

          it "raises a DefinitionParseError" do
            expect{subject.send(:parse_raw_args)}.to raise_error DefinitionParseError
          end
        end
      end
    end
  end
end
