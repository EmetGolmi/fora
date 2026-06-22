class LibraryItem < ApplicationRecord
  belongs_to :owner_profile, class_name: "CivicProfile"

  enum :item_type,  { file: 0, link: 1, embed: 2, note: 3 },                                                                prefix: true
  enum :source,     { upload: 0, clip_instagram: 1, clip_tiktok: 2, clip_pinterest: 3, clip_youtube: 4, link: 5, text: 6 }, prefix: true
  enum :visibility, { private: 0, client_shared: 1, public: 2 },                                                            prefix: true
end
