require 'yaml'

module ResponseMate
  module Nanoc
    module Formatter
      FILTERED_PARAMS = [:oauth_token]

      # @param recording_key <String, Symbol> the key matching a recording in
      # recordings
      # @param options [Hash] options for rendering
      # @option options [Array] :only defines which elements should be created
      # The possible values are:
      # :request -> creates html with request verb, path and params used
      # :description -> creates html with description specified in recordings
      # file (under :meta => :description key)
      # :status -> The response status code (200, 400 etc)
      # :body -> The actual response body
      #
      # @return html for the specified recording
      def render_recording(recording_key, options = {})
        recording = ResponseMate::Tape.load(recording_key)

        if !options[:only]
          options[:only] = [:request, :description, :status, :body]
        end

        result = '<div class="example">'
        result << format_request(recording) if options[:only].include?(:request)
        result << add_toggler
        result << format_description(recording) if options[:only].include?(:description)
        result << format_response(recording, options)
        result << '</div>'

        result
      end

      def text_html(response)
        %(<pre class="highlight"><code>) + CGI.escapeHTML(response) + "</code></pre>"
      end

      private

      def add_toggler
        '<a href="javascript:void(0)" class="toggler" data-target="js-response">' \
          'view response' \
        '</a>'
      end

      def format_request(recording)
        <<-OUT
        <p class="request">
          <span class="verb">#{recording[:request][:verb]}</span>
          <span class="path">#{recording[:request][:url]}</span>
        </p>
        OUT
      end

      def format_response(recording, options)
        out = '<div class="response">'
        out << format_status(recording) if options[:only].include?(:status)
        out << format_body(recording)   if options[:only].include?(:body)
        out << '</div>'
      end

      def format_params(hash)
        output = '<ul class="request-params">'

        output << hash.map { |k, v|
          val = v.is_a?(Hash) ? format_params(v) : v
          val = '[FILTERED]' if FILTERED_PARAMS.include? k.to_sym

          "<li><span class=\"label\">#{k}</span>: #{val}</li>"
        }.join()
        output << "</ul>"
      end

      def format_status(recording)
        %(<pre class="headers"><code>Status: #{recording[:response][:status]}</code></pre>\n)
      end

      def format_body(recording)
        begin
          content = JSON.pretty_generate(JSON.parse(recording[:response][:body]))
        rescue JSON::ParserError
          content = recording[:response][:body]
        end
        %(<pre class="highlight body"><code class="language-javascript">%s</code></pre>) %
          content
      end

      def format_description(recording)
        return '' if !recording[:meta] || !recording[:meta][:description]

        description = recording[:meta][:description]

        %(<div class="request-description"> Description: #{description}</div>)
      end
    end
  end
end

include ResponseMate::Nanoc::Formatter
