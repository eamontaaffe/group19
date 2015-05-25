module NewReading

  def new_BOMreading
    update = Datum.new(location: self)
    update.import_BOMdata
    update.save
  end

  def new_FIOreading
    update = Datum.new(location: self)
    update.import_FIOdata
    update.save
  end

end