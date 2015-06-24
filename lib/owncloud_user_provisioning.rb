require "owncloud_user_provisioning/version"
require "faraday"
require "awesome_print"
require "pry-byebug"
require "nokogiri"
module OwncloudUserProvisioning
  # Your code goes here...
  def self.conn
    conn ||= Faraday.new(url: 'http://cloud.espm.br/ocs/v1.php/cloud/') do |faraday|
      faraday.adapter Faraday.default_adapter
      faraday.basic_auth('admin', 'espm@cloud2015')
    end
    conn

  end
  def self.get_users(user_name: nil)
    params = {search: user_name } if user_name
    response = conn.get 'users' , params
    Nokogiri::XML(response.body)
  end

  def self.get_user(user_name: nil)
    raise(ArgumentError, "user_name is required") if user_name.nil?

    response = conn.get "users/#{user_name}"
    Nokogiri::XML(response.body)
  end


end
