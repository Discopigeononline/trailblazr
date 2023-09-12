class UserMailer < ApplicationMailer
  def hello
    @user = params[:user]
    @itinerary = params[:itinerary]
    mail(to: email_address_with_name(@user.email, @user.first_name), subject: "Hello #{@user.first_name}")
  end
end
