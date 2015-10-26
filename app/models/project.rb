class Project < ActiveRecord::Base
  has_many :elements
  attr_accessor :element_file

  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9_\-]+\Z/ },
    uniqueness: true
  validates :font_size, numericality: { greater_than: 0 }
  validates :random_num, numericality: { greater_than: 0 }
  validates :max_width, numericality: { greater_than: 0 }
  validates :element_file, presence: true, on: :create
  validate :element_file_validation, on: :create

  def element_file_validation
    return if element_file.nil?
    lineno = 0
    CSV.foreach(element_file.tempfile.path, col_sep: "\t") do |row|
      lineno += 1
      next if row.size == 0
      if row.size != 3
        errors.add(:element_file, "Line #{lineno}: too many/few #{row.size} fileds")
      end
      gid = row[0]
      eid = row[1]
      body = row[2]
      element = elements.build(gid: gid, eid: eid, body: body)
      unless element.valid?
        element.errors.each do |key, msg|
          errors.add(:element_file, "Line #{lineno}: #{key} #{msg}")
        end
      end
    end
  end

  def random_elements(gid, seed)
    gid_elements = elements.where(gid: gid).order(:id).to_a
    unless seed.nil?
      random = Random.new(seed)
      gid_elements.shuffle!(random: random)
    end
    return gid_elements
  end

  def get_max_element_num_per_gid
    elements.group(:gid).count.values.max
  end

  # Set font family and size and return Draw
  def get_draw
    draw = Magick::Draw.new
    draw.font = Settings.font.path
    draw.pointsize = font_size
    return draw
  end
end
