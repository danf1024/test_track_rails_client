require 'rails_helper'

RSpec.describe TestTrack::Remote::Visitor do
  describe ".from_identifier" do
    subject { described_class.from_identifier("clown_id", "1234") }
    let(:url) { "http://dummy:fakepassword@testtrack.dev/api/identifier_types/clown_id/identifiers/1234/visitor" }

    before do
      stub_request(:get, url).to_return(status: 200, body: {
        id: "fake_visitor_id_from_server",
        assignment_registry: { time: "clownin_around" }
      }.to_json)
    end

    it "raises when given a blank identifier_type_name" do
      expect { TestTrack::Remote::Visitor.from_identifier("", "1234") }
        .to raise_error("must provide an identifier_type_name")
    end

    it "raises when given a blank identifier_value" do
      expect { TestTrack::Remote::Visitor.from_identifier("clown_id", "") }
        .to raise_error("must provide an identifier_value")
    end

    it "instantiates a Visitor with fake instance attributes" do
      expect(subject.id).to eq("fake_visitor_id")
      expect(subject.assignment_registry).to eq("time" => 'hammertime')
    end

    it "it fetches attributes from the test track server when enabled" do
      with_env(TEST_TRACK_ENABLED: 1) do
        expect(subject.id).to eq("fake_visitor_id_from_server")
        expect(subject.assignment_registry).to eq("time" => "clownin_around")
      end
    end
  end
end