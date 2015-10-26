class Element < ActiveRecord::Base
  belongs_to :project
  validates :gid, presence: true, format: { with: /\A[a-zA-Z0-9_\-]+\Z/ }
end
