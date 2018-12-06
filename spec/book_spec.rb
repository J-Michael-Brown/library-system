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
end
