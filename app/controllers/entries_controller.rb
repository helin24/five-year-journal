class EntriesController < ApplicationController

    def index
        
    end

    def show
        # default landing position if user has an entry for today
        @entry = Entry.find_by(id: params[:id], user_id: session[:user_id])

        @previous_entries = {}
        (1..4).to_a.each do |years_before|
            @previous_entries[years_before] = Entry.find_by(
                display_date: Date.today.prev_year(years_before),
                user_id: session[:user_id])
        end
    end

    def new
        # default landing if there is no entry for today
        @entry = Entry.new
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

end
