gem 'actionmailer', '=3.0.7' 
require 'action_mailer'
puts"Enter password\n"
# pass=STDIN.gets.chomp
pass="gradebookluc2011"

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings =
	{:domain  => 'google.com',
  		:user_name=>"gradebookluc@gmail.com",
       	:enable_starttls_auto => true,
       	:address        => 'smtp.gmail.com',
       	:port           => 587,
       	:authentication => :plain,
   		:password=>pass}
ActionMailer::Base.view_paths = File.dirname(__FILE__)+"/mailer/"
module Gradebook
	class Mailer < ActionMailer::Base
	  def grade_report(to, sender, content_type,content,name)
		@content=content
		@name=name
		puts @content.inspect
		mail(:to=>to,
			:from=>sender,
			:body=>[@content],
			:subject=>"Grades") do |format|
				format.html {render "../mailer/grade_report.html.erb"}
			end 
	  end
	end
end

