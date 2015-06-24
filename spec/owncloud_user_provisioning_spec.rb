require 'spec_helper'

describe OwncloudUserProvisioning do
  it 'has a version number' do
    expect(OwncloudUserProvisioning::VERSION).not_to be nil
  end

  it "lists all users" do
    expect(subject.get_users.class).to be(Nokogiri::XML::Document)
  end

  it "searches for users" do
    expect(subject.get_users(user_name: 'admin').css('users').first.text.strip).to eq("admin")
  end

  it "find a user with no arguments should raise an error" do
    expect { subject.get_user }.to raise_error(ArgumentError)
  end

  it "finds a user by user_name" do
    expect(subject.get_user(user_name: "admin").css("displayname").text).to eq("Admin")
  end
end
