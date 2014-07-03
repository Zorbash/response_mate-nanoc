require 'spec_helper'

describe ResponseMate::Nanoc::Formatter do
  let(:recordings_path) do
    File.join(fixtures_path, 'recordings')
  end

  before do
    ResponseMate::Configuration.any_instance.stub(:output_dir).
      and_return(recordings_path)
  end

  describe "#load_recording" do
    context "when the requested key does not exist" do
      let(:key) { :non_existent_recording }

      it "raises error" do
        expect {
          load_recording(key)
        }.to raise_error(/key was not found/)
      end
    end

    context "when the requested key exists" do
      context "when it does not match a valid yml file" do
        let(:key) { :invalid_yml }

        it "raises error" do
          expect {
            load_recording(key)
          }.to raise_error(/invalid_yml\.yml/)
        end
      end

      context "when it matches a valid yml file" do
        let(:key) { :skus_index }

        it "doesn't raise error" do
          expect {
            load_recording(key)
          }.to_not raise_error
        end

        it "returns the file parsed" do
          expect(load_recording(key)).to eq(
            YAML.load_file(
              File.join(recordings_path, "#{key}.yml")
            ).symbolize_keys
          )
        end
      end
    end
  end

  describe "#render_recording" do
    let(:key) { :skus_index }

    it "calls load_recording with the same key" do
      should_receive(:load_recording).with(:skus_index).and_call_original

      render_recording(:skus_index)
    end

    context "when :request exists in options[:only]" do
      let(:options) { { only: [:request] } }

      it "renders request from yaml file" do
        render_recording(key, options).should match(/verb.*path.*params/)
      end
    end

    context "when :status exists in options[:only]" do
      let(:options) { { only: [:status] } }

      it "renders status from yaml file" do
        render_recording(key, options).should match(/Status: 200/)
      end
    end

    context "when :description exists in options[:only]" do
      let(:options) { { only: [:description] } }

      it "renders description from yaml file" do
        render_recording(key, options).should match(/This is the description/)
      end
    end

    context "when :body exists in options[:only]" do
      let(:options) { { only: [:body] } }

      context "when body is a string" do
        let(:key) { :skus_index_with_string_body }

        it "renders body" do
          subject.render_recording(key, options).should match(/This is a string body/)
        end
      end

      context "when body is JSON" do
        it "renders body prettyfied" do
          expected_string =
            JSON.pretty_generate(
              JSON.parse(subject.load_recording(key)[:body]))

          subject.render_recording(key, options).should match(
            /#{Regexp.escape(expected_string)}/)
        end
      end
    end

    context "more that one key exist in options[:only]" do
      let(:options) { { only: [:request, :status] } }

      it "renders all keys" do
        subject.render_recording(key, options).should match(/verb.*path.*params.*Status: 200/)
      end
    end
  end
end
