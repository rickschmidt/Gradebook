gem 'actionmailer', '=3.0.7' 
require 'action_mailer'
=begin rdoc
	Mailer uses ActionMailer 3.0.7 to send grade reports to students.  
=end
module Gradebook
	class Mailer < ActionMailer::Base
		attr_accessor :email_address
		


=begin rdoc
	Setup Is called to again prompt the user for credentials.  This does not use the token like Client does since actionmailer is not configured that way.
=end
		def setup			
			puts "Enter your full gmail address\n"
			@email_address=STDIN.gets.chomp
								puts "@email #{@email_address}"
			puts"Enter password\n"
			system "stty -echo"
			pass=STDIN.gets.chomp
			
			system "stty echo"
			# pass="gradebookluc2011"
			ActionMailer::Base.raise_delivery_errors = true
			ActionMailer::Base.smtp_settings =
			{:domain  => 'google.com',
		  		:user_name=>@email_address,
		       	:enable_starttls_auto => true,
		       	:address        => 'smtp.gmail.com',
		       	:port           => 587,
		       	:authentication => :plain,
		   		:password=>pass}
				ActionMailer::Base.view_paths = "#{APP_ROOT}/mailer/"	
		end

=begin rdoc
	Sends a grade report.  The method is called from Usergrades.
=end
	  def grade_report(to,sender, content_type,content,name)
		@content=content
		@name=name


		mail(:to=>to,
			:from=>sender,
			:body=>[@content],
			:subject=>"Grades") do |format|
				format.html {render "../mailer/grade_report.html.erb"}
			end 
		Gradebook::Utility::Logger.log("emails-sent","#{Time.now}",to,name,@content.inspect,"\n")
	  end
	end
end

