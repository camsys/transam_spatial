class MapOverlayService < ActiveRecord::Base

  # Include the object key mixin
  include TransamObjectKey

  belongs_to :creator, -> { unscope(where: :active) }, :class_name => "User", :foreign_key => "created_by_user_id"
  belongs_to :organization
  belongs_to :map_overlay_service_type

  validates :map_overlay_service_type,  presence: true
  validates :name,                      presence: true
  validates :url,                       presence: true, uniqueness: {scope: :organization,
    message: "should add one unique service per organization"}

  scope :active, -> {where(active: true)}

  FORM_PARAMS = [
      :name,
      :url,
      :organization_id,
      :map_overlay_service_type_id,
      :active
  ]

  def self.allowable_params
    FORM_PARAMS
  end

  def to_s
    name
  end

end