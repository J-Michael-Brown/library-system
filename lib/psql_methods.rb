def convert_sql_int_array(sql_str)
  sql_int_array = convert_sql_array(sql_str)
  ints = []

  sql_int_array.each do |int|
    if int != "{}"
      ints.push(int.to_i)
    end
  end
  ints
end

def convert_sql_array(sql_str) # input looks like "{1,2,3}" or "{'one','two','three'}"
  if sql_str == nil
    return sql_str
  else
    new_array = (sql_str.split('')-["{","}"]).join.split(',')
  end
end

def convert_sql_str_array(sql_str)
  new_array = convert_sql_array(sql_str)
  output = []
  new_array.each do |item|
    partial = item.split('')[1..-1]
    partial.pop
    output.push(partial.join)
  end
  output
end

def int_array_to_psql(array)#"1,2,3"
  string = []
  array.each do |id|
    string.push(id.to_s)
  end
  output = string.join(',')
  output.concat('}').prepend('{')
end

def str_array_to_psql(array)#'one','two'
  string = []
  array.each do |id|
    string.push(id.to_s.concat("'").prepend("'"))
  end
  output = string.join(',')
  output.concat('}').prepend('{')
end
