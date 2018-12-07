require('spec_helper')
require('pry')



describe(Book) do

  describe("#save") do
    it("lets you save books to the database") do
      book = Book.new({:title => "Epicodus stuff", :author_ids => [0]})
      book.save()
      expect(Book.all()).to(eq([book]))
    end
  end

  describe(".all") do
    it("should display an array of all books") do
      expect(Book.all()).to(eq([]))
    end
  end

  describe(".find") do
    it "returns a stored book based on the given Id." do
      book = Book.new({:title => "Finder Tester", :author_ids => [0]})
      book.save()
      expect(Book.find(book.id)).to(eq(book))
    end
  end

  describe("#==") do
    it("is the same book if it has the same title") do
      book1 = Book.new({:title => "Epicodus stuff", :author_ids => [0]})
      book2 = Book.new({:title => "Epicodus stuff", :author_ids => [0]})
      expect(book1).to(eq(book2))
    end
  end

  describe("#delete!") do
    it "deletes book from database" do
      book3 = Book.new({:title => "deletion test", :author_ids => [0]})
      book3.save()
      expect(Book.all()).to(eq([book3]))
      book3.delete!()
      expect(Book.all()).to(eq([]))
    end
  end

  describe('#clear_authors') do
    it "removes all author ids associated with book. removes all instances of book id under all associated authors." do
      author = prime_author("first name", "last name")
      expect(author.book_ids).to(eq([]))
      book = Book.new({:title => "to clear a mockingbird", :author_ids => [author.id]})
      book.save
      expect(book.author_ids).to(eq([author.id]))
      author = Author.find(author.id)
      expect(author.book_ids).to(eq([book.id]))
      book.clear_authors
      author = Author.find(author.id)
      expect(author.book_ids).to(eq([]))
      expect(book.author_ids).to(eq([]))
    end
  end
end
