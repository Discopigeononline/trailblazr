# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def hello
    user = Struct.new(:first_name, :email, :itinerary).new('Paul', 'paul77uk@gmail.com', "Paul's Journey")
    UserMailer.with(user: user, itinerary: user.itinerary).hello
  end
end
