require 'base64'
require 'faraday'

require 'manatoo/task'

module Manatoo
  # @api_base = 'https://manatoo.io/api'
  @api_base = 'http://localhost:3000/api'
  # @api_key = 'nHmMY4gSh8jutU6Cb5w-pQgZGX7twg'
  class ApiKeyError < StandardError
    def initialize
      super('Missing Manatoo API KEY')
    end
  end

  class << self
    attr_accessor :api_key, :api_base
    attr_reader   :last_response_json
  end

  def self.conn
    raise ApiKeyError.new if self.api_key.nil?

    Faraday.new(self.api_base) do |conn|
      conn.basic_auth(self.api_key, '')
      conn.adapter(Faraday.default_adapter)
    end
  end

  def self.get(url)
    self.conn.get do |req|
      req.url(url)
    end
  end

  def self.request_with_payload(action, url, payload)
    self.conn.send(action) do |req|
      req.url(url)
      req.headers['Content-Type'] = 'application/json'
      req.body = payload.to_json
    end
  end

  def self.post(url, payload)
    self.request_with_payload(:post, url, payload)
  end

  def self.put(url, payload)
    self.request_with_payload(:put, url, payload)
  end

  def self.delete(url, payload)
    self.request_with_payload(:delete, url, payload)
  end
end
