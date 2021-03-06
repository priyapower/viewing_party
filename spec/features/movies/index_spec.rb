require "rails_helper"

RSpec.describe "Discover Landing Page" do
  describe "As an authorized user" do
    before(:each) do
      @wilmer = User.create!(name:"wilmer", email: "wilmer@example.com", password: "User@us3r")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@wilmer)
      results = {:popularity=>1425.298,
                 :vote_count=>1762,
                 :video=>false,
                 :poster_path=>"/riYInlsq2kf1AWoGm80JQW5dLKp.jpg",
                 :id=>497582,
                 :adult=>false,
                 :backdrop_path=>"/kMe4TKMDNXTKptQPAdOF0oZHq3V.jpg",
                 :original_language=>"en",
                 :original_title=>"Enola Holmes",
                 :genre_ids=>[80, 18, 9648],
                 :title=>"Enola Holmes",
                 :vote_average=>7.6,
                 :overview=>
                  "While searching for her missing mother, intrepid teen Enola Holmes uses her sleuthing skills to outsmart big brother Sherlock and help a runaway lord.",
                 :release_date=>"2020-09-23"}
      @movie = MovieFacade.movie_details(results[:id])
    end
    it "can click on button for top 40 movies return" do
      visit '/discover'
      expect(page).to have_button("Top 40 Movies")
    end

    it "can return results of top forty films" do
      visit '/discover'
      click_on "Top 40 Movies"
      expect(current_path).to eq('/movies')
      expect(page).to have_link(@movie.title)
    end

    it "can search for movies, limited by 40" do
      visit '/discover'
      fill_in :query, with: "Enola Holmes"
      click_on "Search Movies"
      expect(current_path).to eq("/movies")
      expect(page).to have_link(@movie.title)
    end
  end

  describe "As a non-registered user" do
    it "can see 400 errors when trying to access the database" do
      visit '/discover'
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
