require 'google/api_client/client_secrets'

class EntriesController < ApplicationController

    def index

    end

    def show
        client_secrets = Google::APIClient::ClientSecrets.load
        auth_client = client_secrets.to_authorization
        auth_client.update!(
            :scope => 'https://www.googleapis.com/auth/gmail.readonly'
        )        

        url = URI.parse('https://www.googleapis.com/gmail/v1/users/helin.shiah@gmail.com/messages')
        # url = URI.parse('https://www.googleapis.com/gmail/v1/users/me/messages')
        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http|
            http.request(req)
        }

        result = JSON.parse(res.read_body)

        p result

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

    def calendar
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
