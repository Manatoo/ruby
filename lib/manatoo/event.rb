require 'json'
require 'plissken'

module Manatoo
  class Event

    # name REQUIRED
    def self.create(attrs)
      raise ArgumentError.new('Event attributes must be passed in as a Hash') unless attrs.is_a?(Hash)

      name = attrs[:name]
      raise ArgumentError.new(
        'A name attribute must be passed in and not blank'
      ) if name.nil? or name.empty?

      url = "events"
      resp = Manatoo.post(url, attrs.merge({
          name: name,
        }))
      JSON.parse(resp.body).to_snake_keys
    end
  end
end
