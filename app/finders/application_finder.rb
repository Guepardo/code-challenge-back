class ApplicationFinder
  DEFAULT_ITEMS_PER_PAGE = 10
  MAX_ITEMS_PER_PAGE = 50

  def self.filter(...)
    new(...).filter
  end
end