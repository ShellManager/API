class PostmarkMailer < ApplicationMailer
    def reset(user)
      @user = user
      mail(
        :to  => user.email,
        :from => ENV['POSTMARK_FROM'],
        :subject => 'Your Reset Code',
        :track_opens => 'true')
    end
    def verify(user)
      @user = user
      mail(
        :to  => user.email,
        :from => ENV['POSTMARK_FROM'],
        :subject => 'Verify Your Account',
        :track_opens => 'true')
    end
end