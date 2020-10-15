class PartiesController < ApplicationController
  before_action :require_user
  
  def new
    @user = current_user
    @movie = MovieFacade.movie_details(params[:movie_id])
    @runtime = @movie.runtime[:total]
    @friendships = User.where(id: @user.friendships.pluck(:friend_id))
  end

  def create
    new_party = format_party
    if new_party.save && params[:participants]
      User.where(id: params[:participants]).each do |participant|
        new_party.party_participants.create(user: participant)
      end
      redirect_to '/dashboard'
    else
      generate_flash(new_party)
      '/party'
    end
  end

  private

  def party_params
    params.permit(:movie_title, :runtime, 'day(1i)', 'day(2i)', 'day(3i)', 'start_time(4i)', 'start_time(5i)')
  end

  def format_party
    schedule = Schedule.new(party_params)

    current_user.parties.new(
      movie_title: party_params[:movie_title],
      runtime: party_params[:runtime],
      date: schedule.date,
      start_time: schedule.start_time
    )
  end
end
