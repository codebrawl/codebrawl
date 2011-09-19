require "net/https"
require "uri"
require 'multi_json'

class Gist
  attr_accessor :code, :body

  def initialize(code, body)
    @code = code.to_i
    @body = body
  end

  def self.fetch(id)
    uri = URI.parse("https://api.github.com/gists/#{id}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)

    new(response.code, response.body)
  end

  def self.comment(id, token, message)
    uri = URI.parse("https://api.github.com/gists/#{id}/comments?access_token=#{token}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = "{\"body\": \"#{message}\"}"

    response = http.request(request)
  end

  def [](attribute)
    MultiJson.decode(body)[attribute]
  end

  def files
    Hash[
      self['files'].map do |key, value|
        value['content'] = nil if key =~ /.*\.png$/
        [key.gsub('.', '*'), value]
      end
    ]
  end
end
