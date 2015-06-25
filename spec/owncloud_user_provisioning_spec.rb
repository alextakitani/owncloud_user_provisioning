require 'spec_helper'

describe OwncloudUserProvisioning do
  it 'has a version number' do
    expect(OwncloudUserProvisioning::VERSION).not_to be nil
  end

  it "lists all users" do
    expect(subject.find_users.class).to be(Nokogiri::XML::Document)
  end

  it "searches for users" do
    expect(subject.find_users(user_name: 'admin').css('users').first.text.strip).to eq("admin")
  end

  it "find a user with no arguments should raise an error" do
    expect { subject.find_user }.to raise_error(ArgumentError)
  end

  it "finds a user by user_name" do
    expect(subject.find_user(user_name: "admin").css("displayname").text).to eq("Admin")
  end

  it "lists the user groups" do
    expect(subject.find_groups(user_name: "admin").css("element").text).to eq("admin")
  end

  context "user maintenance" do
    before do
      subject.remove_user(user_name: 'teste_api')
    end

    it "adds a user" do
      expect(subject.add_user(user_name: 'teste_api', password: 'banana').css("status").text).to eq("ok")
    end

    it "changes the user email" do
      subject.add_user(user_name: 'teste_api', password: 'banana')
      subject.change_email(user_name: 'teste_api', email: 'teste@teste.com')
      expect( subject.find_user(user_name: 'teste_api').css('email').text).to eql('teste@teste.com')
    end

    it "changes the user quota" do
      subject.add_user(user_name: 'teste_api', password: 'banana')
      subject.change_quota(user_name: 'teste_api', quota: '1024' )
      expect( subject.find_user(user_name: 'teste_api').css('quota total').text).to eql('1024')
    end

    it "removes a user" do
      subject.add_user(user_name: 'teste_api', password: 'banana')
      expect(subject.remove_user(user_name: 'teste_api').css("status").text).to eq("ok")
    end

    it "fails trying to add a existing user" do
      subject.add_user(user_name: 'teste_api', password: 'banana')
      expect(subject.add_user(user_name: 'teste_api', password: 'banana').css("message").text).to eq("User already exists")
    end
  end
end
