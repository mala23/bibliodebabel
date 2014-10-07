require 'spec_helper'

feature "User browses the list of links" do
	
	before(:each) {
		Link.create(:uri => "http://www.makersacademy.com",
					:title => "Makers Academy")
	}

	scenario "land on the page" do
		visit '/'
		expect(page).to have_content("Makers Academy")
	end

end