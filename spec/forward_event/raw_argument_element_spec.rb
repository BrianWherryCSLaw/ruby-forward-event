# frozen_string_literal: true

require "forward_event/raw_argument_element"

module ForwardEvent
  RSpec.describe RawArgumentElement do
    describe "private methods" do
      describe ":set_type" do
        data = [
          { input: "OV42", expectation: "ov_code" },
          { input: '"', expectation: "string_delimiter" },
          { input: "(", expectation: "template_name_opener" },
          { input: ")", expectation: "template_name_closer" },
          { input: "BananaOV42 Flume", expectation: "string" }
        ]

        data.each do |datum|
          context "when raw_string is '#{datum[:input]}'" do
            let(:el) { RawArgumentElement.new datum[:input] }

            it "sets type to '#{datum[:expectation]}'" do
              expect(el.type).to eq datum[:expectation]
            end
          end
        end
      end
    end
  end
end
