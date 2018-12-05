require('spec_helper')
require('pry')

describe(Patron) do

  describe("#save") do
    it("lets you save patrons to the database") do
      patron = Patron.new({:name => "Epicodus stuff"})
      patron.save()
      expect(Patron.all()).to(eq([patron]))
    end
  end

  describe(".all") do
    it("should display an array of all patrons") do
      expect(Patron.all()).to(eq([]))
    end
  end

  describe(".find") do
    it "returns a stored patron based on the given Id." do
      patron = Patron.new({:name => "Finder Tester"})
      patron.save()
      expect(Patron.find(patron.id)).to(eq(patron))
    end
  end

  describe("#==") do
    it("is the same patron if it has the same name") do
      patron1 = Patron.new({:name => "Epicodus stuff"})
      patron2 = Patron.new({:name => "Epicodus stuff"})
      expect(patron1).to(eq(patron2))
    end
  end

  describe("#delete!") do
    it "deletes patron from database" do
      patron3 = Patron.new({:name => "deletion test"})
      patron3.save()
      expect(Patron.all()).to(eq([patron3]))
      patron3.delete!()
      expect(Patron.all()).to(eq([]))
    end
  end
end
