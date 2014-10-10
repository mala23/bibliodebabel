require 'spec_helper'

feature "User signs up" do
	
	scenario "when being logged out" do
		expect{ sign_up }.to change(User, :count).by(1)
		expect(page).to have_content("Welcome, alice@example.com")
		expect(User.first.email).to eq("alice@example.com")
	end

	def sign_up(email = "alice@example.com",
				password = "foobar",
				password_confirmation = "foobar")
		visit '/users/new'
		expect(page.status_code).to eq(200)
		fill_in :email, :with => email
		fill_in :password, :with => password
		fill_in :password_confirmation, :with => password_confirmation
		click_button "Sign up"	
	end

	scenario "with a password that does not match" do
		expect{ sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
		expect(current_path).to eq('/users')
		expect(page).to have_content("Password does not match the confirmation")
	end

	scenario "with a email that's been already registered" do
		expect{ sign_up }.to change(User, :count).by(1)
		expect{ sign_up }.to change(User, :count).by(0)
		expect(page).to have_content("This email address is already signed up")
	end

end

feature "User signs in" do

	before(:each) do
		User.create(:email => "foo@bar.io",
					:password => "foo",
					:password_confirmation => "foo")
	end

	scenario "with correct credentials" do
		visit '/'
		expect(page).not_to have_content("Welcome, foo@bar.io")
		sign_in("foo@bar.io", "foo")
		expect(page).to have_content("Welcome, foo@bar.io")
	end

	def sign_in(email, password)
		visit '/sessions/new'
		fill_in 'email', :with => email
		fill_in 'password', :with => password
		click_button 'Sign in'
	end

end

