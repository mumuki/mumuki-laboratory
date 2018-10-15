def set_token!(token)
  @request.env["HTTP_AUTHORIZATION"] = token
end

def set_api_client!(api_client)
  set_token! api_client.token
end
