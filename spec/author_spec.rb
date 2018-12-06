require('spec_helper')
require('pry')

def make_test_author(first_name = 'chester')
  test_author = Author.new({
    :book_ids => [],
    :first_name => first_name,
    :last_name => 'tester'
    })
  test_author.save()
  test_author
end

describe(Author) do

  describe("#save") do
    it("lets you save author to the author database") do
      author = Author.new({
        :book_ids => [],
        :first_name => 'first name',
        :last_name => 'last name'
      })
      author.save()
      expect(Author.all()).to(eq([author]))
    end
  end

  describe(".all") do
    it("should display an array of all authors") do
      author = Author.new({
        :book_ids => [1,2,3],
        :first_name => 'first name',
        :last_name => 'last name'
      })
      expect(Author.all()).to(eq([]))
      author.save()
      expect(Author.all()).to(eq([author]))
    end
  end

  describe(".find") do
    it "returns a stored author based on the given Id." do
      test_author = make_test_author
      expect(Author.find(test_author.id)).to(eq(test_author))
    end
  end

  describe("#==") do
    it("is the same author if it has the same name") do
      author1 = Author.new({
        :book_ids => [],
        :first_name => 'first name',
        :last_name => 'last name'
      })
      author2 = Author.new({
        :book_ids => [],
        :first_name => 'first name',
        :last_name => 'last name'
      })
      expect(author1).to(eq(author2))
    end
  end

  describe("#delete!") do
    it "deletes author from database" do
      test_author = make_test_author
      expect(Author.all()).to(eq([test_author]))
      test_author.delete!()
      expect(Author.all()).to(eq([]))
    end
  end
end
