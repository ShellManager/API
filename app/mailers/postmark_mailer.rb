class PostmarkMailer < ApplicationMailer
    def reset(user)
      @user = user
      mail(
        :to  => user.email,
        :from => 'system@m6.nz',
        :subject => 'Your Reset Code',
        :track_opens => 'true')
    end
    def verify(user)
      @user = user
      mail(
        :to  => user.email,
        :from => 'system@m6.nz',
        :subject => 'Verify Your Account',
        :track_opens => 'true')
    end
end