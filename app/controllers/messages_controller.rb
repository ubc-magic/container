class MessagesController < ApplicationController
 
 before_filter :only => [:new, :create] do |c| c.signed_in_user params[:id], params[:display_name]  end 

 def new
   @display_id = params[:id]
   @display = Display.find_by_unique_id(@display_id)
   @user = User.find_by_id(cookies[:user_id])
   @user_to_display = User.find_by_id(params[:user_id])
   @gift_today = @user_to_display.gifts.where("from_id = ? AND created_at >= ?", @user.id, Time.zone.now.beginning_of_day)
   @favour_today = Favour.where("from_id = ? AND to_id = ? AND created_at >= ?", @user.id, @user_to_display.id, Time.zone.now.beginning_of_day)
   @favours_pending = Favour.where("from_id = ? AND to_id = ? AND reciprocated = ? AND created_at >= ?", @user.id, @user_to_display.id, false, Time.zone.now.beginning_of_week)
   @gifts_sent = @user_to_display.gifts.where("from_id = ?", @user.id)

   @messages = Message.where(:to => [@user_to_display.id, @user.id], :from => [@user.id, @user_to_display.id]).order("created_at DESC")
   #@messages.last.update_attributes(read: true)

   unread_message = Message.where(:to => [@user.id], :from => [@user_to_display.id]).last
   unless unread_message.nil? then
     unread_message.update_attributes(read:true)
   end

   @message = Message.new
   #log_usage
   if (Container::Application.config.log_usage)
     Log.create(controller: 'messages', method: 'new', user_id: @user.id, display_id: @display_id, params: params, remote_ip: request.remote_ip )
   end
   render :layout => 'mobile'
 end

 def create
   @user = User.find_by_id(cookies[:user_id])
   @display = Display.find_by_unique_id(params[:message][:display_id])
   @display_id = @display.unique_id
   @message = Message.new(from: params[:message][:from_id], message: params[:message][:message], to: params[:message][:to_id])
   @user_to_display = User.find_by_id(params[:message][:to_id])
   @gift_today = @user_to_display.gifts.where("from_id = ? AND created_at >= ?", @user.id, Time.zone.now.beginning_of_day)
   @favour_today = Favour.where("from_id = ? AND to_id = ? AND created_at >= ?", @user.id, @user_to_display.id, Time.zone.now.beginning_of_day)
   @favours_pending = Favour.where("from_id = ? AND to_id = ? AND reciprocated = ? AND created_at >= ?", @user.id, @user_to_display.id, false, Time.zone.now.beginning_of_week)
   @gifts_sent = @user_to_display.gifts.where("from_id = ?", @user.id)

   @messages = Message.where(:to => [@user_to_display.id, @user.id], :from => [@user.id, @user_to_display.id]).order("created_at DESC")
   if @message.save 
     @message = Message.new
     #log_usage
     if (Container::Application.config.log_usage)
       Log.create(controller: 'messages', method: 'create', user_id: @user.id, display_id: @display_id, params: params, remote_ip: request.remote_ip)
     end
     render 'new', :layout => 'mobile'
   else
     render 'new', :layout => 'mobile'
   end
 
 end


end
