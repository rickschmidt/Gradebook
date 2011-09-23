GData::Client::Base.module_eval do
	def make_request(method, url, body = '')
        headers = self.prepare_headers
               request = GData::HTTP::Request.new(url, :headers => headers, 
                 :method => method, :body => body)
               
               if @auth_handler and @auth_handler.respond_to?(:sign_request!)
                 @auth_handler.sign_request!(request)
               end
        
               service = http_service.new
               response = service.make_request(request)
               
               case response.status_code  
               when 200, 201, 302, 304
                 #Do nothing, it's a success.
               when 401, 403
                 raise AuthorizationError.new(response)
               when 400
                 raise BadRequestError.new(response)
               when 409
                 raise VersionConflictError.new(response)
               when 500
                 raise ServerError.new(response)
               else
                 raise UnknownError.new(response)
               end
               
               return response
      end
end