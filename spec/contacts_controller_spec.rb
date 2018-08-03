require 'spec_helper'
require 'pry'

describe 'index action' do
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
      get '/contacts'
      binding.pry
      expect(page.body).to include("Please sign in to view content")
    end
  end
end