require 'spec_helper'

describe OwncloudUserProvisioning do

  it "lists all users" do
    expect(subject.find_users.class).to be(Nokogiri::XML::Document)
  end

  it "searches for users" do
    expect(subject.find_users(user_name: 'admin').css('users').first.text.strip).to include("admin")
  end

  it "find a user with no arguments should raise an error" do
    expect { subject.find_user }.to raise_error(ArgumentError)
  end

  it "finds a user by user_name" do
    expect(subject.find_user(user_name: "admin").css("displayname").text).to eq("Admin")
  end

  it "lists the user groups" do
    expect(subject.find_user_groups(user_name: "admin").css("element").text).to include("admin")
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
      subject.change_quota(user_name: 'teste_api', quota: '1024MB' )      
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

  context "group" do

      before do
        subject.remove_user(user_name: 'teste_api')
      end

      it "adding a user to an unexisting group returns an error" do
        subject.add_user(user_name: 'teste_api', password: 'banana')
        req = subject.add_to_group(user_name: 'teste_api', group: 'teste_api')
        expect(req.css("status").text).to eq("failure")
        expect(req.css("statuscode").text).to eq("102")
      end

      it "lists all groups" do
        expect(subject.find_groups.class).to be(Nokogiri::XML::Document)
      end

      it "finds groups by name" do
        expect(subject.find_groups(group: "admin").css("element").text).to include("admin")
      end

      it "creates a group" do
        expect(subject.create_group(group_id: 'teste_api').css("statuscode").text).to eq("100")
      end

      it "add a user to a group" do
        subject.add_user(user_name: 'teste_api', password: 'banana')
        req = subject.add_to_group(user_name: 'teste_api', group: 'teste_api')
        expect(req.css("statuscode").text).to eq("100")
      end

      it "deletes a group" do
        expect(subject.remove_group(group_id: 'teste_api').css("statuscode").text).to eq("100")
      end



      # it "creates a group" do
      #   expect(subject.create_group(group_id: 'teste_api').css("statuscode")).to eq("100")
      # end

  end


end
