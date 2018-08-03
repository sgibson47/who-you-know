require 'spec_helper'
require 'pry'

describe 'contacts index action' do
  context 'logged in' do
    it 'lets a user view her own contacts index if logged in' do
      user1 = User.create(:username => "Terrbear", :email => "tjeffords@nypd.nyc.gov", :password => "Cagney&Lacey")
      contact1 = Contact.create(:name => "Raymond Holt", :user_id => user1.id)

      user2 = User.create(:username => "Charles", :email => "cboyle@nypd.nyc.gov", :password => "Nikolaj")
      contact2 = Contact.create(:name => "Rosa Diaz", :user_id => user2.id)

      visit '/contacts'

      fill_in(:username, :with => "Terrbear")
      fill_in(:password, :with => "Cagney&Lacey")
      click_button 'submit'
      visit "/contacts"
      expect(page.body).to include(contact1.name)
      expect(page.body).not_to include(contact2.name)
    end
  end

  context 'logged out' do
    it 'does not let a user a contacts index if not logged in' do
      visit '/contacts'
      expect(page.body).to include("Please sign in to view content")
    end
  end
end

describe 'contacts new action' do
  context 'logged in' do
    it 'lets user view new contact form if logged in' do
      user = User.create(:username => "Terrbear", :email => "tjeffords@nypd.nyc.gov", :password => "Cagney&Lacey")

      params = {
        :username => "Terrbear",
        :password => "Cagney&Lacey"
      }
      post '/login', params
      
      visit '/contacts/new'
      expect(page.status_code).to eq(200)
    end

    it 'lets user create a contact if they are logged in' do
      user = User.create(:username => "Terrbear", :email => "tjeffords@nypd.nyc.gov", :password => "Cagney&Lacey")

      visit '/login'

      fill_in(:username, :with => "Terrbear")
      fill_in(:password, :with => "Cagney&Lacey")
      click_button 'submit'
      

      visit '/contacts/new'
      fill_in("contact[name]", :with => "Jake Peralta")
      click_button 'Create New Contact'

      user = User.find_by(:username => "Terrbear")
      contact = Contact.find_by(:name => "Jake Peralta")
      expect(contact).to be_instance_of(Contact)
      expect(contact.user_id).to eq(user.id)
      expect(page.status_code).to eq(200)
    end

    it 'does not let a user create a contact with no name' do
      user = User.create(:username => "Terrbear", :email => "tjeffords@nypd.nyc.gov", :password => "Cagney&Lacey")

      visit '/login'

      fill_in(:username, :with => "Terrbear")
      fill_in(:password, :with => "Cagney&Lacey")
      click_button 'submit'
      

      visit '/contacts/new'
      fill_in("contact[name]", :with => "")
      click_button 'Create New Contact'

      expect(Contact.find_by(:name => "")).to eq(nil)
      expect(page.body).to include("A contact must have a name.")
    end
  end

  context 'logged out' do
    it 'does not let user view new contact form if not logged in' do
      visit '/contacts/new'
      expect(page.body).to include("Please sign in to view content")
    end
  end
end