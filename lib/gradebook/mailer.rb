require 'action_mailer'

ActionMailer::Base.smtp_settings =
{:domain  => 'google.com',
  :user_name=>"gradebookluc@gmail.com",
       :enable_starttls_auto => true,
       :address        => 'smtp.gmail.com',
       :port           => 587,

       :authentication => :plain,
   :password=>"gradebookluc2011"}
module Gradebook
	class FileMailer < ActionMailer::Base
	  def file(to, sender, content_type,content)
		subj="Grades"

	    #standard ActionMailer message setup
	    recipients  to
	    from        sender
	    subject     subj
	    #setting the body explicitly means we don't have to provide a separate template file
	    body        content

	    # #set up the attachment
	    # 	    attachment  :content_type => content_type,
	    # 	                :body         => "A"

	  end
	end
end