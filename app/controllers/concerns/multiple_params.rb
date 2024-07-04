module MultipleParams
  def values(request, params, param_key)
    current_query_string = URI(request.url).query
    values = URI::decode_www_form(current_query_string).select { |pair| pair[0] == param_key }
                                              .collect { |pair| pair[1] }
    params['expand'] = values
    params
  end
end