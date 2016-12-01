class EntriesController < ApplicationController

  def index

  end

  def show
    # default landing position if user has an entry for today
    @entry = Entry.find_by(id: params[:id], user_id: session[:user_id])

    @previous_entries = {}
    (1..4).to_a.each do |years_before|
      @previous_entries[years_before] = Entry.find_by(
        # Instead of Date.today, this will have to be the date that the user perceives (same process as under Entry#new)
        display_date: Date.today.prev_year(years_before),
        user_id: session[:user_id])
    end
  end

  def new
    # default landing if there is no entry for today
    @entry = Entry.new
    
    # instead make display_date the date based on user's timezone
    # probably means using Time or DateTime instead of Date
    # Get time, then transform time with user's timezone, then make into a date to send to entry
    @entry.display_date = Date.today
  end

  def create
    @entry = Entry.new
    @entry.user_id = session[:user_id]
    @entry.display_date = params[:display_date]
    @entry.text = params[:entry][:text]
    @entry.is_public = params[:entry][:is_public]
    @entry.save()

    redirect_to entry_path(@entry)
  end

  def choose
    entry = Entry.find_by(user_id: session[:user_id], display_date: Date.today)
    puts entry

    if entry
      redirect_to entry_path(entry)
    else
      redirect_to new_entry_path
    end

  end

  def calendar
    # Same process as Entry#new to get date for user
    @current_month = Date.today.month
    current_year = Date.today.year
    beginning_date = Date.new(current_year, @current_month, 1)
    end_date = Date.new(current_year, @current_month, -1)

    month_entries = Entry.where(
    user_id: session[:user_id],
    display_date: beginning_date .. end_date
    )

    @days_entries = {}
    (beginning_date .. end_date).each do |day|
    day_entry = month_entries.find { |entry| entry.display_date == day }
    @days_entries[day] = day_entry
    end
  end

end
