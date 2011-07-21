gem 'gdata2', '=1.0'

=begin rdoc
    This module wraps the available google CL Docs tasks in ruby methods.
=end
module Gradebook
    class GoogleCL
   
        def upload(course_sheet_path)
            `google docs upload #{course_sheet_path} `
        end
        
        def list
            `google docs list`
        end
        
        def get(title,download_to)
            `google docs get --title #{title} #{download_to}`
        end
        
        def edit(title)
            #can also be used for viewing
            `google docs edit  --title #{title}`
        end
        
        def delete(title)
            `google docs delete  --title #{title}`
        end
    end
end