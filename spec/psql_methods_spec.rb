require('spec_helper')

describe('convert_sql_int_array') do
  it "converts an array of numbers from psql to an array that can be read by ruby" do
    expect(convert_sql_int_array("{1,2,3}")).to(eq([1,2,3]))
  end
end

describe('convert_sql_str_array') do
  it "converts an array of strings from psql to an array that can be read by ruby" do
    expect(convert_sql_str_array("{'one','two','three'}")).to(eq(['one','two','three']))
  end
end

describe('int_array_to_psql') do
  it "converts an array of integers from ruby to an array that can be read by psql" do
    expect(int_array_to_psql([1,2,3])).to(eq('{1,2,3}'))
  end
end

describe('str_array_to_psql') do
  it "converts an array of strings from ruby to an array that can be read by psql" do
    expect(str_array_to_psql(['one','two','three'])).to(eq("{'one','two','three'}"))
  end
end
