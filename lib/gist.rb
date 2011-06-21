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

  def [](attribute)
    MultiJson.decode(body)[attribute]
  end
end