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
    conn ||= Faraday.new(url: 'https://cloud.espm.br/ocs/v1.php/cloud/') do |faraday|
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

  def self.find_user_groups(user_name: nil)
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

  def self.add_to_group(user_name: nil, group: nil)
    fail(ArgumentError, "user_name is required") if user_name.nil?
    fail(ArgumentError, "group is required") if group.nil?
    response = conn.post "users/#{user_name}/groups", groupid: group
    Nokogiri::XML(response.body)
  end

  def self.find_groups(group: nil)
    params = { search: group } if group
    response = conn.get 'groups', params
    Nokogiri::XML(response.body)
  end

  def self.create_group(group_id: nil)
    fail(ArgumentError, "group_id is required") if group_id.nil?
    params = {groupid: group_id}
    response = conn.post 'groups', params
    Nokogiri::XML(response.body)
  end

  def self.remove_group(group_id: nil)
    fail(ArgumentError, "group_id is required") if group_id.nil?
    params = {groupid: group_id}
    response = conn.delete "groups/#{group_id}"
    Nokogiri::XML(response.body)
  end

  # def self.find_group(group: nil)
  #   fail(ArgumentError, "group is required") if group.nil?
  #   response = conn.get "groups/#{group}"
  #   Nokogiri::XML(response.body)
  # end


end
