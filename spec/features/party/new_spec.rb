require "rails_helper"

RSpec.describe "New Viewing Party Page", type: :feature do
  describe "As a registered user" do
    before :each do
      @twilight_sparkle = User.create!(name:"Twilight", email:"twilight_sparkle@email.com", password:"User@us3r")

      @spike = User.create!(name:"spike", email:"spike@email.com", password:"User@us3r")
      @starlight_glimmer = User.create!(name:"Starlight", email:"starlight_glimmer@email.com", password:"User@us3r")
      @pinkie_pie = User.create!(name:"pinkie", email:"pinkie_pie@email.com", password:"User@us3r")

      @rainbow_dash = User.create!(name:"rainbow dash", email:"rainbow_dash1@email.com", password:"User@us3r")

      @twilight_sparkle.friendships.create!(friend:@spike)
      @spike.friendships.create!(friend:@twilight_sparkle)
      @twilight_sparkle.friendships.create!(friend:@starlight_glimmer)
      @starlight_glimmer.friendships.create!(friend:@twilight_sparkle)
      @rainbow_dash.friendships.create!(friend:@twilight_sparkle)
      @twilight_sparkle.friendships.create!(friend:@rainbow_dash)

      @test_party = @rainbow_dash.parties.create!(movie_title: "Monsters, Inc", runtime: 160, date: "10/24/2020", start_time: "18:00")
      @test_party.party_participants.create!(user:@twilight_sparkle)

      movie = {:popularity=>1425.298,
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

        @enola = MovieFacade.movie_details(movie[:id])

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@twilight_sparkle)
      end

      it "can create a new party routed from a movie details page" do
        visit "/movies/#{@enola.id}"
        within '#title' do
          click_button "Create Viewing Party for Movie"
        end

        expect(current_path).to eq("/#{@enola.id}/party/new")
        within '#header' do
          expect(page).to have_content("Welcome #{@twilight_sparkle.name.capitalize}!")
        end

        within '#party' do
          expect(page).to have_content("Viewing Party Details")

          expect(page).to have_content("Movie Title")
          expect(page).to have_selector("input[name= 'movie_title']")

          expect(page).to have_content("Duration of Party")
          expect(page).to have_selector("input[name= 'runtime']")
          fill_in :runtime, with: 160

          expect(page).to have_content("Day")
          within '.date-select' do
            find("option[value='2020']").select_option
            find("option[value='10']", text: 'October').select_option
            find("option[value='15']", text: '15').select_option
          end

          expect(page).to have_content("Start time")
          within '.time-select' do
            find("option[value='19']", text: '7 PM').select_option
            find("option[value='00']", text: '00').select_option
          end
          within '#include-friends' do
            expect(page).to have_content(@spike.name.titleize)
            expect(page).to have_content(@starlight_glimmer.name.titleize)
            expect(page).to have_content(@rainbow_dash.name.titleize)

            within "#friend-#{@spike.id}" do
              page.check("participants_", :match => :first)
            end

            within "#friend-#{@starlight_glimmer.id}" do
              page.check("participants_", :match => :first)
            end
          end

          click_button "Create Party"
          expect(current_path).to eq('/dashboard')
    #       party = Party.last
    #       # party_check = Party.where(movie_title: @enola.movie_title)
    #
    # # require "pry"; binding.pry
    # # require "pry"; binding.pry
    # # require "pry"; binding.pry
    #       within '#parties' do
    #         within "#party-#{party.id}" do
    #           expect(page).to have_content(party.movie_title)
    #           expect(page).to have_content(party.date)
    #           expect(page).to have_content(party.start_time)
    #           expect(page).to have_content("Hosting")
    #         end
    #         within "#party-#{@test_party.id}" do
    #           expect(page).to have_content(@test_party.movie_title)
    #           expect(page).to have_content(@test_party.date)
    #           expect(page).to have_content(@test_party.start_time)
    #           expect(page).to have_content("Invited")
    #         end
    #       end
        end
      end


      it "can see a failure if " do
        visit "/movies/#{@enola.id}"
        within '#title' do
          click_button "Create Viewing Party for Movie"
        end

        expect(current_path).to eq("/#{@enola.id}/party/new")
        within '#header' do
          expect(page).to have_content("Welcome #{@twilight_sparkle.name.capitalize}!")
        end

        within '#party' do
          expect(page).to have_content("Viewing Party Details")

          expect(page).to have_content("Movie Title")
          expect(page).to have_selector("input[name= 'movie_title']")

          expect(page).to have_content("Duration of Party")
          expect(page).to have_selector("input[name= 'runtime']")
          fill_in :runtime, with: 160

          expect(page).to have_content("Day")
          within '.date-select' do
            find("option[value='2020']").select_option
            find("option[value='10']", text: 'October').select_option
            find("option[value='15']", text: '15').select_option
          end

          expect(page).to have_content("Start time")
          within '.time-select' do
            find("option[value='19']", text: '7 PM').select_option
            find("option[value='00']", text: '00').select_option
          end
          click_button "Create Party"
          expect(current_path).to eq("/party")
        end
      end
    end

    # describe "As a non-registered user" do
    #   it "can see 400 errors when trying to access the database" do
    #     visit "/viewing-party/new"
    #     expect(page).to have_content("The page you were looking for doesn't exist.")
    #   end
    # end
  end
