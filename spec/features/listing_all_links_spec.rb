require 'spec_helper'

feature "User browses the list of links" do

  before(:each) {
	Link.create(:uri => "http://www.makersacademy.com",
		:title => "Makers Academy",
		:tags => [Tag.first_or_create(:text => 'education')])
	Link.create(:uri => "http://www.google.com",
		:title => "Google",
		:tags => [Tag.first_or_create(:text => 'search')])
	Link.create(:uri => "http://www.bing.com",
		:title => "Bing",
		:tags => [Tag.first_or_create(:text => 'search')])
	Link.create(:uri => "http://www.code.org",
		:title => "Code.org",
		:tags => [Tag.first_or_create(:text => 'education')])
	}
	
	scenario "land on the page" do
		visit '/'
		expect(page).to have_content("Makers Academy")
	end

	scenario "User filters links by a tag" do
		visit '/tags/search'
		expect(page).not_to have_content("MakersAcademy")
		expect(page).not_to have_content("Code.org")
		expect(page).to have_content("Google")
		expect(page).to have_content("Bing")
	end

end