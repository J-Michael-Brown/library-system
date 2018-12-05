require('spec_helper')
require('pry')

describe(Checkout) do

  describe("#save") do
    it("lets you save checkouts to the database") do
      checkout = Checkout.new({:patron_id => 1, :book_id => 1})
      checkout.save()
      expect(Checkout.all()).to(eq([checkout]))
    end
  end

  describe(".all") do
    it("should display an array of all checkouts") do
      expect(Checkout.all()).to(eq([]))
    end
  end

  describe(".find") do
    it "returns a stored checkout based on the given Id." do
      checkout = Checkout.new({:patron_id => 1, :book_id => 1})
      checkout.save()
      expect(Checkout.find(checkout.id)).to(eq(checkout))
    end
  end

  describe("#==") do
    it("is the same checkout if it has the same name") do
      checkout1 = Checkout.new({:patron_id => 1, :book_id => 1})
      checkout2 = Checkout.new({:patron_id => 1, :book_id => 1})
      expect(checkout1).to(eq(checkout2))
    end
  end

  describe("#delete!") do
    it "deletes checkout from database" do
      checkout3 = Checkout.new({:patron_id => 1, :book_id => 1})
      checkout3.save()
      expect(Checkout.all()).to(eq([checkout3]))
      checkout3.delete!()
      expect(Checkout.all()).to(eq([]))
    end
  end
end
