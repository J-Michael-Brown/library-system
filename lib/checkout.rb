class Checkout
  attr_reader :book_id, :patron_id, :id, :date
  def initialize(attributes)
    @book_id = attributes.fetch(:book_id)
    @patron_id = attributes.fetch(:patron_id)
    if attributes.include?(:date)
      @date = (attributes.fetch(:date))
    else
      @date = Time.new
    end
    if attributes.include?(:id)
      @id = (attributes.fetch(:id))
    else
      @id = nil
    end
  end

  def save
    result = DB.exec("INSERT INTO checkouts (book_id, patron_id, date) VALUES ('#{@book_id}', '#{@patron_id}', '#{@date.to_s}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def delete!()
    DB.exec("DELETE FROM checkouts WHERE id = #{self.id}")
    new_checkout = Checkout.all
    if new_checkout.include?(self)
      return 'deleted'
    else
      return 'didn\'t work'
    end
  end

  def self.all
    returned_checkouts = DB.exec("SELECT * FROM checkouts;")
    checkouts = []
    returned_checkouts.each() do |checkout|
      book_id = checkout.fetch("book_id").to_i
      id = checkout.fetch("id").to_i()
      patron_id = checkout.fetch("patron_id").to_i
      date = checkout.fetch("date")
      checkouts.push(Checkout.new({:book_id => book_id, :id => id, :patron_id => patron_id, :date => date}))
    end
    checkouts
  end

  def self.find(id)
    result = DB.exec("SELECT * FROM checkouts WHERE id = #{id};")
    output_checkout = Checkout.new({
      :patron_id => result.first.fetch("patron_id").to_i,
      :book_id => result.first.fetch("book_id").to_i,
      :id => result.first.fetch("id").to_i,
      :date => Time.new(result.first.fetch("date"))
      })
  end

  def ==(another_checkout)
    self.patron_id().==(another_checkout.patron_id()).&(self.id().==(another_checkout.id())).&(self.book_id().==(another_checkout.book_id()))
  end
end
