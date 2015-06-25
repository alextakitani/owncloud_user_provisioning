require "owncloud_user_provisioning/version"
require "faraday"
require "nokogiri"
require 'dotenv'
Dotenv.load
begin
  require 'pry-byebug'
  require "awesome_print"
rescue LoadError
end
module OwncloudUserProvisioning

  def self.conn
    conn ||= Faraday.new(url: 'http://cloud.espm.br/ocs/v1.php/cloud/') do |faraday|
      # faraday.response :logger
      # faraday.response :raise_error
      faraday.request :url_encoded
      faraday.basic_auth(ENV['OWNCLOUD_USER'], ENV['OWNCLOUD_PASSWORD'])
      faraday.adapter Faraday.default_adapter
    end
    conn
  end
  def self.find_users(user_name: nil)
    params = { search: user_name } if user_name
    response = conn.get 'users', params
    Nokogiri::XML(response.body)
  end

  def self.find_user(user_name: nil)
    fail(ArgumentError, "user_name is required") if user_name.nil?
    response = conn.get "users/#{user_name}"
    Nokogiri::XML(response.body)
  end

  def self.find_groups(user_name: nil)
    fail(ArgumentError, "user_name is required") if user_name.nil?
    response = conn.get "users/#{user_name}/groups"
    Nokogiri::XML(response.body)
  end

  def self.add_user(user_name: nil, password: nil)
    fail(ArgumentError, "user_name is required") if user_name.nil?
    fail(ArgumentError, "password is required") if password.nil?
    response = conn.post 'users', userid: user_name, password: password
    Nokogiri::XML(response.body)
  end

  def self.remove_user(user_name: nil)
    fail(ArgumentError, "user_name is required") if user_name.nil?
    response = conn.delete "users/#{user_name}"
    Nokogiri::XML(response.body)
  end

  def self.change_email(user_name: nil, email: nil)
    fail(ArgumentError, "user_name is required") if user_name.nil?
    fail(ArgumentError, "email is required") if email.nil?
    response = conn.put "users/#{user_name}", key: "email", value: email
    Nokogiri::XML(response.body)
  end

  def self.change_quota(user_name: nil, quota: nil)
    fail(ArgumentError, "user_name is required") if user_name.nil?
    fail(ArgumentError, "quota is required") if quota.nil?
    response = conn.put "users/#{user_name}", key: "quota", value: quota
    Nokogiri::XML(response.body)
  end
end
