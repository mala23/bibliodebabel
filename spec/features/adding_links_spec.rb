require 'spec_helper'

feature "User adds new link" do
	
	scenario "add a link" do
		expect(Link.count).to eq (0)
		visit '/'
		add_link("http://www.makersacademy.com/", "Makers Academy")
		expect(Link.count).to eq(1)
		link = Link.first
		expect(link.uri).to eq("http://www.makersacademy.com/")
		expect(link.title).to eq("Makers Academy")
	end

	def add_link(uri, title)
		within('#new-link') do
			fill_in 'uri', :with => uri
			fill_in 'title', :with => title
			click_button 'Add link'
		end

	end

end