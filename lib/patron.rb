class Patron
  attr_reader :name, :id
  def initialize(attributes)
    @name = attributes.fetch(:name)
    if attributes.include?(:id)
      @id = (attributes.fetch(:id).to_i)
    else
      @id = nil
    end
  end

  def save
    result = DB.exec("INSERT INTO patrons (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def delete!()
    DB.exec("DELETE FROM patrons WHERE id = #{self.id}")
    DB.exec("DELETE FROM checkouts WHERE patron_id = #{self.id}")
    new_patron = Patron.all
    if new_patron.include?(self)
      return 'deleted'
    else
      return 'didn\'t work'
    end
  end

  def self.all
    returned_patrons = DB.exec("SELECT * FROM patrons;")
    patrons = []
    returned_patrons.each() do |patron|
      name = patron.fetch("name")
      id = patron.fetch("id").to_i()
      patrons.push(Patron.new({:name => name, :id => id}))
    end
    patrons
  end

  def self.find(id)
    result = DB.exec("SELECT * FROM patrons WHERE id = #{id};")
    output_patron = Patron.new({
      :name => result.first.fetch("name"),
      :id => result.first.fetch("id").to_i
      })
  end

  def ==(another_patron)
    self.id().==(another_patron.id()).&(self.name().==(another_patron.name()))
  end
end
